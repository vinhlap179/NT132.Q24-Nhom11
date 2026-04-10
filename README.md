Bài thực hành OSPF với Docker Container

Bài thực hành này trình bày cách thiết lập và cấu hình mạng OSPF bằng cách sử dụng các Docker container. Bài thực hành bao gồm các Dockerfile đã được cấu hình sẵn, các tập lệnh (script) để xây dựng và triển khai mạng, cùng với một sơ đồ mạng (topology) để hướng dẫn quá trình thiết lập.

Tổng quan bài thực hành
Bài thực hành mô phỏng một mạng OSPF đơn vùng (single-area) sử dụng Docker container. Mỗi container đóng vai trò là một bộ định tuyến (router) hoặc máy chủ (host), chạy FRR (Free Range Routing) để cấu hình và kiểm tra OSPF.

Sơ đồ mạng (Topology)
Tham khảo topology.png để có cái nhìn trực quan về mạng OSPF.

Điều kiện tiên quyết
Đã cài đặt Docker và Docker Compose trên máy của bạn.

Có hiểu biết cơ bản về OSPF.

Môi trường Linux với bash.

Hướng dẫn thiết lập
Bước 1: Xây dựng các Docker Container
Chạy script sau để xây dựng các Docker image cho bài thực hành:

Bash
bash build-docker-containers.sh
Bước 2: Triển khai các Container
Sử dụng script triển khai để khởi động các container dựa trên sơ đồ mạng OSPF:

Bash
bash deploy_containers.sh
Nếu bạn thử chạy lệnh ping từ host1 đến host2, bạn sẽ nhận được kết quả tương tự như dưới đây:

Bash
docker exec -ti host1 ping 20.20.20.20
PING 20.20.20.20 (20.20.20.20) 56(84) bytes of data.
From 10.10.10.254 icmp_seq=1 Destination Net Unreachable
From 10.10.10.254 icmp_seq=2 Destination Net Unreachable
From 10.10.10.254 icmp_seq=3 Destination Net Unreachable
From 10.10.10.254 icmp_seq=4 Destination Net Unreachable
Bước 3: Cấu hình OSPF
Khi các container đã được triển khai, hãy cấu hình OSPF trên các router bằng script được cung cấp:

Bash
bash configure_ospf.sh
Nếu bạn đang để lệnh ping chạy, bạn sẽ thấy sau một lúc (khi các bảng định tuyến đã hội tụ đến tất cả các container) nó cũng sẽ bắt đầu phản hồi lại.

Bash
docker exec -ti host1 ping 20.20.20.20
PING 20.20.20.20 (20.20.20.20) 56(84) bytes of data.
From 10.10.10.254 icmp_seq=1 Destination Net Unreachable
From 10.10.10.254 icmp_seq=2 Destination Net Unreachable
From 10.10.10.254 icmp_seq=3 Destination Net Unreachable
From 10.10.10.254 icmp_seq=4 Destination Net Unreachable
From 10.10.10.254 icmp_seq=43 Destination Net Unreachable
From 10.10.10.254 icmp_seq=85 Destination Net Unreachable
64 bytes from 20.20.20.20: icmp_seq=122 ttl=58 time=0.103 ms
64 bytes from 20.20.20.20: icmp_seq=123 ttl=58 time=0.039 ms
64 bytes from 20.20.20.20: icmp_seq=124 ttl=58 time=0.043 ms
64 bytes from 20.20.20.20: icmp_seq=125 ttl=58 time=0.032 m
Bước 4: Xác minh cấu hình OSPF
Sau khi cấu hình OSPF, hãy xác minh rằng các router đã thiết lập mối quan hệ láng giềng (neighbor) và các route đang được lan truyền (propagate) như mong đợi:

Đăng nhập vào các router bằng lệnh docker exec:

Bash
docker exec -it router1 vtysh
Sử dụng các lệnh sau trong vtysh để xác minh OSPF:

Mối quan hệ láng giềng (Neighbor relationships):

Bash
show ip ospf neighbor
Bảng định tuyến (Routing table):

Bash
show ip route ospf
Cơ sở dữ liệu OSPF (OSPF database):

Bash
show ip ospf database
Bạn cũng có thể xem bảng định tuyến mang tính biểu thị của các router:

Bash
   docker exec -it router1 vtysh
Bảng định tuyến (Routing table):

Bash
show ip route
Kết quả đầu ra biểu thị như sau:

Bash
O   10.10.10.0/24 [110/10] is directly connected, eth1, weight 1, 00:03:06
C>* 10.10.10.0/24 is directly connected, eth1, 00:04:28
L>* 10.10.10.254/32 is directly connected, eth1, 00:04:28
O   10.10.11.0/29 [110/10] is directly connected, eth2, weight 1, 00:03:06
C>* 10.10.11.0/29 is directly connected, eth2, 00:04:28
L>* 10.10.11.2/32 is directly connected, eth2, 00:04:28
O   10.10.11.8/29 [110/10] is directly connected, eth3, weight 1, 00:03:06
C>* 10.10.11.8/29 is directly connected, eth3, 00:04:28
L>* 10.10.11.10/32 is directly connected, eth3, 00:04:28
O>* 10.10.11.16/29 [110/20] via 10.10.11.3, eth2, weight 1, 00:02:20
O>* 10.10.11.24/29 [110/20] via 10.10.11.11, eth3, weight 1, 00:02:20
O>* 20.20.20.0/24 [110/60] via 10.10.11.3, eth2, weight 1, 00:02:11
  * via 10.10.11.11, eth3, weight 1, 00:02:11
O>* 20.20.21.0/29 [110/40] via 10.10.11.3, eth2, weight 1, 00:02:11
  * via 10.10.11.11, eth3, weight 1, 00:02:11
O>* 20.20.21.8/29 [110/40] via 10.10.11.3, eth2, weight 1, 00:02:11
  * via 10.10.11.11, eth3, weight 1, 00:02:11
O>* 20.20.21.16/29 [110/50] via 10.10.11.3, eth2, weight 1, 00:02:11
  * via 10.10.11.11, eth3, weight 1, 00:02:11
O>* 20.20.21.24/29 [110/50] via 10.10.11.3, eth2, weight 1, 00:02:11
  * via 10.10.11.11, eth3, weight 1, 00:02:11
O>* 30.30.30.0/29 [110/30] via 10.10.11.3, eth2, weight 1, 00:02:11
  * via 10.10.11.11, eth3, weight 1, 00:02:11
C>* 172.17.0.0/16 is directly connected, eth0, 00:04:28
L>* 172.17.0.4/32 is directly connected, eth0, 00:04:28
Bạn có thể thấy rằng OSPF duy trì tất cả các đường đi cho mỗi mạng (đường đi chính và đường đi dự phòng).

Nếu chúng ta ngắt kết nối (bring down) một giao diện mạng (interface), bạn sẽ thấy không có hiện tượng gì xảy ra ở kết nối ping ban đầu.
Ví dụ:

Bắt đầu chạy lệnh ping từ host1 đến host2

Bash
docker exec -ti host1 ping 20.20.20.20
Xác minh rằng lưu lượng mạng đang đi qua một router, ví dụ: router6

Bash
docker exec -ti router6 bash
Kết quả mẫu:

Bash
root@1387ad5a06a7:/# tcpdump -i eth1
tcpdump: verbose output suppressed, use -v[v]... for full protocol decode
listening on eth1, link-type EN10MB (Ethernet), snapshot length 262144 bytes
13:13:36.416599 IP 10.10.10.10 > 20.20.20.20: ICMP echo request, id 28, seq 1, length 64
13:13:36.416623 IP 20.20.20.20 > 10.10.10.10: ICMP echo reply, id 28, seq 1, length 64
13:13:36.544094 IP router5.net9 > 224.0.0.5: OSPFv2, Hello, length 48
13:13:36.851960 IP 1387ad5a06a7 > 224.0.0.5: OSPFv2, Hello, length 48
13:13:37.418955 IP 10.10.10.10 > 20.20.20.20: ICMP echo request, id 28, seq 2, length 64
13:13:37.418968 IP 20.20.20.20 > 10.10.10.10: ICMP echo reply, id 28, seq 2, length 64
Ở đây lưu lượng mạng đang sử dụng đường đi cho cả hai chiều (yêu cầu & phản hồi) - có thể bạn sẽ chỉ thấy một trong hai luồng (luồng thứ hai đang sử dụng đường đi thứ hai).
3. Ngắt kết nối một network interface và quan sát những gì xảy ra với lệnh ping

Bash
docker network disconnect net8 router6 
Kết quả của lệnh ping không bị thay đổi - lưu lượng mạng đã được định tuyến qua đường đi dự phòng

Bash
docker exec -ti host1 ping 20.20.20.20
PING 20.20.20.20 (20.20.20.20) 56(84) bytes of data.
64 bytes from 20.20.20.20: icmp_seq=1 ttl=58 time=0.066 ms
64 bytes from 20.20.20.20: icmp_seq=2 ttl=58 time=0.043 ms
64 bytes from 20.20.20.20: icmp_seq=3 ttl=58 time=0.027 ms
64 bytes from 20.20.20.20: icmp_seq=4 ttl=58 time=0.031 ms
64 bytes from 20.20.20.20: icmp_seq=5 ttl=58 time=0.028 ms
64 bytes from 20.20.20.20: icmp_seq=6 ttl=58 time=0.026 ms
64 bytes from 20.20.20.20: icmp_seq=7 ttl=58 time=0.048 ms
64 bytes from 20.20.20.20: icmp_seq=8 ttl=58 time=0.045 ms
64 bytes from 20.20.20.20: icmp_seq=9 ttl=58 time=0.027 ms
64 bytes from 20.20.20.20: icmp_seq=10 ttl=58 time=0.038 ms
64 bytes from 20.20.20.20: icmp_seq=11 ttl=58 time=0.025 ms
64 bytes from 20.20.20.20: icmp_seq=12 ttl=58 time=0.039 ms
64 bytes from 20.20.20.20: icmp_seq=13 ttl=58 time=0.032 ms
64 bytes from 20.20.20.20: icmp_seq=14 ttl=58 time=0.029 ms
64 bytes from 20.20.20.20: icmp_seq=15 ttl=58 time=0.031 ms
64 bytes from 20.20.20.20: icmp_seq=16 ttl=58 time=0.030 ms
64 bytes from 20.20.20.20: icmp_seq=17 ttl=58 time=0.026 ms
64 bytes from 20.20.20.20: icmp_seq=18 ttl=58 time=0.045 ms
64 bytes from 20.20.20.20: icmp_seq=19 ttl=58 time=0.029 ms
64 bytes from 20.20.20.20: icmp_seq=20 ttl=58 time=0.044 ms
Bước 5: Phân tích lưu lượng mạng OSPF
Tệp ospf-capture.pcap chứa bản chụp gói tin của lưu lượng OSPF. Bạn có thể sử dụng Wireshark để phân tích các gói tin OSPF Hello, LSA, v.v. Bạn cũng có thể tự mình chụp (capture) một bản bằng cách chạy lệnh tcpdump trên interface của router, trước khi áp dụng script configure_ospf.sh.

Dọn dẹp (Cleanup)
Để dọn dẹp bài thực hành và xóa bỏ tất cả các container, hãy chạy:

Bash
bash cleanup_containers.sh
Ghi chú thêm
Hãy chỉnh sửa các Dockerfile (Dockerfile_host1 và Dockerfile_router) nếu bạn cần tùy chỉnh các container image.

Các script được thiết kế nhằm mục đích đơn giản. Hãy thoải mái tùy chỉnh chúng cho các tình huống nâng cao hơn.
