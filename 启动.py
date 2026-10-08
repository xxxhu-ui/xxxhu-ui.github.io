# -*- coding: utf-8 -*-
"""像素肉鸽 —— 本地启动器
双击运行（或 python 启动.py），然后按提示用手机扫码 / 输网址。
关掉这个黑窗口就等于关掉服务器。
"""
import http.server
import socket
import os
import sys
import webbrowser

PORT = 8000
HERE = os.path.dirname(os.path.abspath(__file__))
PAGE = "index.html"


class Handler(http.server.SimpleHTTPRequestHandler):
    def __init__(self, *a, **k):
        super().__init__(*a, directory=HERE, **k)

    def guess_type(self, path):
        # 保证中文不乱码
        if str(path).lower().endswith((".html", ".htm")):
            return "text/html; charset=utf-8"
        if str(path).lower().endswith(".js"):
            return "text/javascript; charset=utf-8"
        return super().guess_type(path)

    def end_headers(self):
        self.send_header("Cache-Control", "no-store")
        super().end_headers()

    def log_message(self, *a):
        pass  # 别刷屏


def lan_ip():
    s = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
    try:
        s.connect(("8.8.8.8", 80))
        return s.getsockname()[0]
    except Exception:
        return "127.0.0.1"
    finally:
        s.close()


def show_qr(text):
    """有二维码库就打一个，没有就算了。"""
    try:
        import segno
        segno.make(text, error="m").terminal(compact=True)
        return True
    except Exception:
        pass
    try:
        import qrcode
        q = qrcode.QRCode(border=1)
        q.add_data(text)
        q.make()
        q.print_ascii(invert=True)
        return True
    except Exception:
        return False


def main():
    try:
        sys.stdout.reconfigure(line_buffering=True)
    except Exception:
        pass
    ip = lan_ip()
    url = "http://%s:%d/%s" % (ip, PORT, PAGE)
    local = "http://127.0.0.1:%d/%s" % (PORT, PAGE)

    print()
    print("=" * 52)
    print("            像 素 肉 鸽 · 无 尽 试 炼")
    print("=" * 52)
    print()
    print("  【电脑上先试玩】")
    print("     " + local)
    print()
    print("  【手机上玩】  手机浏览器打开：")
    print("     " + url)
    print()
    if show_qr(url):
        print("     上面这个方块，用手机相机扫它就行")
    else:
        print("     （没装二维码库，直接手输上面那串网址）")
    print()
    print("-" * 52)
    print("  手机连不上？按顺序检查：")
    print("   1. 手机和电脑必须在【同一个网络】")
    print("      最稳的做法：用手机开热点，电脑连上去")
    print("   2. 第一次启动，Windows 会弹防火墙窗口")
    print("      → 必须点【允许访问】（专用网络 + 公用网络都勾）")
    print("   3. 网址里的 IP 可能会变，每次重开看这里的输出")
    print()
    print("  关掉这个窗口 = 关掉服务器")
    print("-" * 52)
    print()

    try:
        webbrowser.open(local)
    except Exception:
        pass

    try:
        srv = http.server.ThreadingHTTPServer(("", PORT), Handler)
    except OSError as e:
        print("!! 启动失败：%s" % e)
        print("   端口 %d 被占了，可能已经开着一个了。" % PORT)
        input("   按回车退出...")
        return

    try:
        srv.serve_forever()
    except KeyboardInterrupt:
        print("\n已关闭。")
    finally:
        srv.server_close()


if __name__ == "__main__":
    main()
