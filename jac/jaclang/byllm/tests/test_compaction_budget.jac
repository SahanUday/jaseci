"""Compaction sizes what it keeps in tokens, not in messages.

The trigger is a token ratio, so what compaction keeps and what it asks the summariser to
shrink are budgeted in tokens too. These tests pin that with the default settings, which
keep three assistant rounds.
"""

import jaclang.byllm.llm as _byllm_llm_mod;
import from jaclang.byllm.lib { MockLLM }
import from support { call, finish, roles, sent_messages }


# About 300 tokens: bigger than the tail budget of a 1000-token window.
def read_chunk -> str {
    return "x" * 1200;
}


def make_round(idx: int, result_chars: int) -> list[any] {
    return [
        {
            "role": "assistant",
            "content": None,
            "tool_calls": [
                {
                    "id": f"call_{idx}",
                    "function": {"name": "search", "arguments": f'{{"q":"q{idx}"}}'}
                }
            ]
        },
        {
            "role": "tool",
            "content": "r" * result_chars,
            "tool_call_id": f"call_{idx}",
            "name": "search"
        }
    ];
}


def history(round_count: int, result_chars: int) -> list[any] {
    messages: list[any] = [
        {"role": "system", "content": "You are a helpful assistant."},
        {"role": "user", "content": "Do the thing."}
    ];
    for idx in range(1, round_count + 1) {
        messages += make_round(idx, result_chars);
    }
    return messages;
}


def kept_call_ids(compacted: list[any]) -> list[str] {
    return [
        m["tool_calls"][0]["id"]
        for m in compacted
        if m["role"] == "assistant"
    ];
}


test "the default settings compact when the threshold is crossed after two rounds" {
    llm = MockLLM(
        ctx_window=1000,
        outputs=[
            call("read_chunk", usage={"prompt_tokens": 100}),
            call("read_chunk", usage={"prompt_tokens": 900}),
            "SUMMARY_TEXT",
            finish("ok")
        ]
    );

    def ask(q: str) -> str by llm(tools=[read_chunk]);

    assert ask("go") == "ok";
    # The third request is the summariser's: it saw only the first round.
    assert [len(m) for m in llm.sent("messages")] == [2, 4, 2, 5];
    assert roles(llm, 3) == ["system", "user", "user", "assistant", "tool"];
    assert "SUMMARY_TEXT" in sent_messages(llm, 3)[2]["content"];
}


test "the kept tail is the newest rounds that fit the token budget" {
    # A 4000-token window gives a tail budget of 1000 tokens.
    cases = [
        ("every requested round fits", 1000, ["call_2", "call_3", "call_4"]),
        ("the oldest round is dropped to fit", 1500, ["call_3", "call_4"]),
        ("the newest round is kept however large", 6000, ["call_4"])
    ];
    for (label, result_chars, expected) in cases {
        compacted: list[any] = list(
            _byllm_llm_mod._default_compact(
                history(4, result_chars), 3, MockLLM(outputs=["S"]), ctx_window=4000
            )
        );
        assert kept_call_ids(compacted) == expected , (
            f"{label}: kept {kept_call_ids(compacted)}"
        );
    }
}
