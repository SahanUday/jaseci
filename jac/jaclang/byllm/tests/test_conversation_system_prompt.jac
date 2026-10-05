"""The system prompt belongs to the call, never to the caller's `conversation=` list.

Compaction hands back copies of the messages it was given, the system prompt among
them. Whatever the list holds is replayed on the next call, so a stored copy would be
sent next to the real one every time.
"""

import from jaclang.byllm.lib { MockLLM }
import from support { call, finish, roles, say }


def step -> str {
    return "stepped";
}


"""Keeps the system prompt and the task, as the `on_compaction` docs describe."""
def keep_two(msgs: list[any], keep_recent: int) -> list[any] {
    return [msgs[0], msgs[1]];
}


def stored_roles(history: list[dict[str, any]]) -> list[str] {
    return [m["role"] for m in history];
}


test "a compaction hook that keeps the system prompt does not store it" {
    history: list[dict[str, any]] = [];
    llm = MockLLM(
        ctx_window=1000,
        outputs=[
            call("step", usage={"prompt_tokens": 100}),
            call("step", usage={"prompt_tokens": 850}),
            finish("ok")
        ]
    );

    def ask(q: str) -> str by llm(
        tools=[step], conversation=history, on_compaction=keep_two
    );

    ask("hello");

    assert "system" not in stored_roles(history) , f"stored: {stored_roles(history)}";
}


test "the built-in compaction does not store the system prompt" {
    history: list[dict[str, any]] = [];
    llm = MockLLM(
        ctx_window=1000,
        outputs=[
            call("step", usage={"prompt_tokens": 100}),
            call("step", usage={"prompt_tokens": 100}),
            call("step", usage={"prompt_tokens": 850}),
            say("SUMMARY"),
            finish("ok")
        ]
    );

    def ask(q: str) -> str by llm(
        tools=[step], conversation=history, keep_recent_iterations=1
    );

    ask("hello");

    assert any("SUMMARY" in str(m.get("content")) for m in history) , f"the run did not compact: {history}";
    assert "system" not in stored_roles(history) , f"stored: {stored_roles(history)}";
}


test "later turns send one system prompt however often compaction ran" {
    history: list[dict[str, any]] = [];
    llm = MockLLM(
        ctx_window=1000,
        outputs=[
            call("step", usage={"prompt_tokens": 850}),
            finish("first"),
            call("step", usage={"prompt_tokens": 850}),
            finish("second"),
            finish("third")
        ]
    );

    def ask(q: str) -> str by llm(
        tools=[step], conversation=history, on_compaction=keep_two
    );

    ask("one");
    ask("two");
    ask("three");

    assert "system" not in stored_roles(history) , f"stored: {stored_roles(history)}";
    last_request = len(llm.sent("messages")) - 1;
    assert roles(llm, last_request).count("system") == 1 , (
        f"the last request: {roles(llm, last_request)}"
    );
}


test "a system message already stored in the list is not replayed or kept" {
    history: list[dict[str, any]] = [
        {"role": "system", "content": "STORED_SYSTEM_PROMPT"},
        {"role": "user", "content": "earlier question"},
        {"role": "assistant", "content": "earlier answer"}
    ];
    llm = MockLLM(outputs=[say("ok")]);

    def ask(q: str) -> str by llm(conversation=history);

    ask("next question");

    assert roles(llm) == ["system", "user", "assistant", "user"] , (
        f"sent: {roles(llm)}"
    );
    assert "STORED_SYSTEM_PROMPT" not in str(llm.sent("messages")[0]);
    assert stored_roles(history) == ["user", "assistant", "user", "assistant"] , (
        f"stored: {stored_roles(history)}"
    );
}
