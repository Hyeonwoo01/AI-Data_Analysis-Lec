"""
[예제] 보고용 차트 리디자인 — 8단계 적용
================================================================
본 코드를 TODO 과정을 하나씩 수행하면서 차트를 완성한다.
실행 → 이미지 확인 → 다시 수정을 반복하며 확인

이 차트가 답해야 할 핵심 질문
    "어떤 채널의 비중이 늘고 줄었는가?"
────────────────────────────────────────────────────────────────
"""
import os

import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
from matplotlib import font_manager


def _find_korean_font() -> str | None:
    preferred = [
        "Malgun Gothic",
        "AppleGothic",
        "Apple SD Gothic Neo",
        "NanumGothic",
    ]
    installed = {f.name for f in font_manager.fontManager.ttflist}
    for name in preferred:
        if name in installed:
            return name
    return None

def setup(font_size: int = 10) -> str | None:
    font = _find_korean_font()
    if font:
        plt.rcParams["font.family"] = font
    else:
        print(
            "[경고] 한글 폰트를 찾지 못했습니다. 한글 라벨이 네모(□)로 보일 수 있습니다."
        )

    plt.rcParams.update({
        "font.size": font_size,
        "axes.unicode_minus": False,   # 음수 부호 깨짐 방지 — 한글 폰트와 세트로 필수
        "axes.titlecolor": INK,
        "axes.titlesize": font_size + 2,
        "savefig.dpi": 150,
        "figure.dpi": 110,
    })
    return font

def save(fig, path: str, tight: bool = True):
    """결과 이미지를 저장하고 경로를 출력한다."""
    os.makedirs(os.path.dirname(path) or ".", exist_ok=True)
    if tight:
        fig.savefig(path, bbox_inches="tight", pad_inches=0.25)
    else:
        fig.savefig(path)
    plt.close(fig)
    print(f"  저장됨 → {path}")
    return path

def channel_mix() -> pd.DataFrame:
    return pd.DataFrame({
        "채널": ["검색", "SNS", "추천", "제휴", "기타"],
        "2년 전": [42.0, 18.0, 12.0, 21.0, 7.0],
        "현재":   [28.0, 34.0, 19.0, 13.0, 6.0],
    })

HAIR = "#d6d3d1" 
INK = "#0c0a09"
GRAY = "#c9c5c1"
ACCENT = "#2f6f5e"
WARN = "#c2543d"
GRAY_D = "#a8a29e"

OUT = os.path.join('.', "output")


def build_after():
    d = channel_mix()
    d["변화"] = d["현재"] - d["2년 전"]

    # ── STEP 03. 정렬 ─────────────────────────────────────
    # TODO: 변화량 기준으로 정렬하세요. (힌트: d.sort_values)

    fig, ax = plt.subplots(figsize=(7.8, 4.4))
    y = np.arange(len(d))

    # ── STEP 04. 회색조 + 강조 1색 ────────────────────────
    # TODO: 10 이상 증가한 채널은 ACCENT, 감소한 채널은 WARN, 변화가 작으면 GRAY.
    colors = [GRAY] * len(d)

    # 덤벨(dumbbell) 차트 — 두 시점을 선으로 잇고 점 두 개로 표현
    for i, r in enumerate(d.itertuples()):
        ax.plot([r._2, r.현재], [i, i], color=HAIR, linewidth=2, zorder=1)
        ax.scatter(r._2, i, s=70, color=GRAY, zorder=3)
        ax.scatter(r.현재, i, s=70, color=colors[i], zorder=3)

    # ── STEP 01. 축 정리 ──────────────────────────────────
    # TODO: x축 하한을 0으로 두세요. (덤벨은 위치 부호화이므로 0 시작이 안전)
    # ax.set_xlim(...)

    # ── STEP 02. 정크 제거 ────────────────────────────────
    # TODO: 위·오른쪽·아래 축선을 지우세요. (힌트: ax.spines[{direction}].set_visible())
    

    ax.set_yticks(y, d["채널"], fontsize=10.5)
    ax.invert_yaxis()

    # ── STEP 05. 직접 라벨링 ──────────────────────────────
    # TODO: 각 점 옆에 값을, 오른쪽 끝에 변화량(+/-)을 표기하세요.

    # ── STEP 06. Action Title ─────────────────────────────
    # TODO: 제목을 결론 문장으로 바꾸세요.
    ax.set_title("채널별 비율", loc="left", fontsize=15, color=INK, pad=22)

    # ── STEP 07. 메타 정보 ────────────────────────────────
    # TODO: 출처 · 기간 · N수 · 단위를 하단 캡션으로 넣으세요.

    return fig


if __name__ == "__main__":
    setup()
    fig = build_after()
    save(fig, os.path.join(OUT, "after_mine.png"))
    print("\n── STEP 08 ──")
    print("이 차트가 말하는 것을 한 문장으로 적어 보세요:")
    print("  →                                                        ")
