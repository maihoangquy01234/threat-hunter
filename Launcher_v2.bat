@echo off
:: Chuyển bảng mã sang UTF-8 để hiển thị Tiếng Việt có dấu
chcp 65001 >nul
color 0A
title USB Threat Hunter Toolkit

:MENU
cls
echo ===================================================================
echo               CÔNG CỤ GIÁM SÁT KẾT NỐI MÃ ĐỘC
echo ===================================================================
echo.
echo   [1] Cập nhật dữ liệu IP Threat Intel (Cần Internet)
echo   [2] Quét nhanh tức thì  (10 Phút)
echo   [3] Quét tiêu chuẩn     (30 Phút)
echo   [4] Quét chuyên sâu     (1 Tiếng)
echo   [5] Quét tùy chỉnh      (Nhập thời gian theo phút)
echo   [6] Thoát công cụ
echo   [7] Cẩm nang Điều tra và Xử lý Sự cố (IR Cheat Sheet)
echo.
echo ===================================================================
set /p choice="Nhập lựa chọn của bạn (1-7): "

if "%choice%"=="1" goto UPDATE
if "%choice%"=="2" goto SCAN10
if "%choice%"=="3" goto SCAN30
if "%choice%"=="4" goto SCAN60
if "%choice%"=="5" goto SCANCUSTOM
if "%choice%"=="6" goto EXIT
if "%choice%"=="7" goto GUIDE

:: Nếu nhập sai, quay lại Menu
goto MENU

:UPDATE
cls
echo Đang kết nối đến các máy chủ Threat Intel (OSINT)...
Updater.exe
echo.
pause
goto MENU

:SCAN10
cls
NetHunter.exe -t 10m
echo.
pause
goto MENU

:SCAN30
cls
NetHunter.exe -t 30m
echo.
pause
goto MENU

:SCAN60
cls
NetHunter.exe -t 1h
echo.
pause
goto MENU

:SCANCUSTOM
cls
echo ===================================================================
echo                   TÙY CHỈNH THỜI GIAN QUÉT
echo ===================================================================
set /p custom_time="Nhập số phút bạn muốn giám sát (VD: 5, 45, 120): "
cls
echo [*] Đang khởi động quét trong %custom_time% phút...
:: Thêm chữ 'm' vào sau biến custom_time để thành định dạng phút (vd: 15m)
NetHunter.exe -t %custom_time%m
echo.
pause
goto MENU

:GUIDE
cls
echo ===================================================================
echo             CẨM NANG ĐIỀU TRA NHANH (IR CHEAT SHEET)
echo ===================================================================
echo.
echo MẸO: Hãy mở một cửa sổ PowerShell hoặc CMD bằng quyền Administrator
echo      và Copy/Paste các lệnh dưới đây để điều tra.
echo.
echo --- 1. ĐIỀU TRA TIẾN TRÌNH (PROCESS) ---
echo Xem toàn bộ danh sách tiến trình đang chạy (Tìm tên giả mạo):
echo   tasklist
echo.
echo Xem toàn bộ tiến trình kèm theo tài khoản User đang chạy chúng:
echo   tasklist /v
echo.
echo Tìm đường dẫn và lệnh gốc đã gọi mã độc lên (Thay PID bằng số thật):
echo   wmic process where processid="PID" get name,executablepath,commandline
echo.
echo Xem tiến trình này đang tải những file DLL nào (Tìm DLL Hijacking):
echo   tasklist /m /fi "pid eq PID"
echo.
echo --- 2. ĐIỀU TRA KẾT NỐI MẠNG ---
echo Kiểm tra xem PID này đang mở những Port nào khác:
echo   netstat -ano ^| findstr "PID"
echo.
echo --- 3. TIÊU DIỆT MÃ ĐỘC (KILL) ---
echo Ép buộc tắt ngay lập tức một tiến trình và các tiến trình con của nó:
echo   taskkill /F /T /PID PID
echo.
echo --- 4. KIỂM TRA MÃ ĐỘC KHỞI ĐỘNG CÙNG WINDOWS (PERSISTENCE) ---
echo Liệt kê các phần mềm tự chạy khi bật máy:
echo   wmic startup get caption,command
echo.
echo Liệt kê các tác vụ chạy ngầm (Scheduled Tasks) đáng ngờ:
echo   schtasks /query /fo LIST /v ^| findstr /i "Command"
echo.
echo --- 5. LẤY MÃ BĂM (HASH) ĐỂ KIỂM TRA TRÊN VIRUSTOTAL ---
echo Lấy mã SHA256 của file nghi ngờ (Thay đường dẫn thực tế vào):
echo   certutil -hashfile "C:\Đường\Dẫn\Đến\File.exe" SHA256
echo.
echo --- 6. XEM KẾT NỐI DNS ---
echo   ipconfig /displaydns
echo ===================================================================
pause
goto MENU

:EXIT
exit