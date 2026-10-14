import socket
import time
import datetime

# Các IP lấy từ file threats.bin
target_ips = ["209.33.37.101"]
ports = [443]

print("=== CÔNG CỤ GIẢ LẬP KẾT NỐI MÃ ĐỘC (DEMO) ===")
print("[*] Chế độ: Beaconing mỗi 30 giây, tự động kết thúc sau 10 phút.")

start_time = time.time()
duration_seconds = 10 * 60  # Tổng thời gian chạy: 10 phút (600 giây)
interval_seconds = 30       # Khoảng cách giữa mỗi lần gửi: 30 giây
beacon_count = 0

# Tiếp tục lặp nếu thời gian hiện tại trừ thời gian bắt đầu vẫn nhỏ hơn 10 phút
while time.time() - start_time < duration_seconds:
    beacon_count += 1
    current_time_str = datetime.datetime.now().strftime("%H:%M:%S")
    print(f"\n[{current_time_str}] --- Bắt đầu đợt gửi thứ {beacon_count} ---")
    
    for ip in target_ips:
        for port in ports:
            print(f"[*] Đang mô phỏng C2 beaconing tới {ip}:{port}...")
            try:
                s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
                s.settimeout(1.5)
                # Tool Go sẽ bắt được kết nối ở bước này
                s.connect((ip, port))
                
                # Gửi traffic HTTP giả lập
                payload = f"GET /api/v1/command HTTP/1.1\r\nHost: {ip}\r\nUser-Agent: Mozilla/5.0\r\n\r\n"
                s.sendall(payload.encode())
                s.close()
                print("  [+] Payload đã được gửi đi.")
            except Exception as e:
                print("  [-] Kết nối bị từ chối/timeout.")
    
    # Tính toán thời gian đã trôi qua để quyết định có ngủ tiếp không
    elapsed = time.time() - start_time
    remaining = duration_seconds - elapsed
    
    if remaining > 0:
        # Nếu thời gian còn lại ít hơn 30s, chỉ ngủ phần thời gian còn lại
        sleep_time = min(interval_seconds, remaining)
        print(f"[*] Tạm nghỉ {sleep_time:.0f} giây... (Thời gian còn lại: {remaining/60:.1f} phút)")
        time.sleep(sleep_time)

print("\n=== HOÀN TẤT QUÁ TRÌNH GIẢ LẬP SAU 10 PHÚT ===")