```
Create volume failed due to quota exceeded in spite of quota number updated
cinder quota-show admin
cinder quota-show tenan_id (neutron net-list)
cinder quota-update --volumes 100 tenn_id


```



``` sh
git config --global user.name "anhbka"
git config --global user.email "anhnt@mail.com"
cat ~/.gitconfig
config --list
```



<pre>timedatectl set-timezone Asia/Ho_Chi_Minh
. admin-openrc
openstack network create  --share --external --provider-physical-network provider --provider-network-type flat provider

openstack subnet create --network provider \
  --allocation-pool start=192.168.239.210,end=192.168.239.250 \
  --dns-nameserver 8.8.8.8 --gateway 192.168.239.1 \
  --subnet-range 192.168.239.0/24 provider

  
openstack subnet create --network selfservice \
  --dns-nameserver 8.8.8.8 --gateway 10.10.10.1 \
  --subnet-range 10.10.10.0/24 selfservice  


ovs-vsctl set bridge br0 protocols=OpenFlow13
ovs-vsctl set-fail-mode br0 secure
ovs-vsctl list-br
ovs-vsctl list-ports br0
ovs-vsctl list interface
ovs-ofctl show  // hien thi thong tin ngan gon ve port
ovs-dpctl show //show port
ovs-dpctl dump-flows  

chmod +x *.sh
  
neutron -netlist
openstack show flavor
nova boot --flavor m1.nano --image 0d628fbc-3169-4a12-9361-664119a06b7c  --nic net-id=5f54b578-01a2-4d9f-acf0-faaf926f832e  --availability-zone nova:compute1 vm03  
  
 
openstack security group rule create --proto icmp default
openstack security group rule create --proto tcp --dst-port 22 default
  
openstack flavor create --id 0 --vcpus 1 --ram 64 --disk 1 m1.nano

. admin-openrc
wget http://download.cirros-cloud.net/0.3.5/cirros-0.3.5-x86_64-disk.img
apt update && apt dist-upgrade -y

superuser ALL=(ALL) NOPASSWD:ALL
%supergroup  ALL=(ALL) NOPASSWD:ALL



</pre>
<pre>Cần nắm dược 5 – 4 – 3 trong Cloud Computing: đó là 5 đặc tính, 4 mô hình dịch vụ và 3 mô hình triển khai.

5 đặc điểm: (giải thích chi tiết sẽ có bài viết cụ thể hơn)

Khả năng thu hồi và cấp phát tài nguyên (Rapid elasticity)
Truy nhập qua các chuẩn mạng (Broad network access)
Dịch vụ sử dụng đo đếm được (Measured service,) hay là chi trả theo mức độ sử dụng pay as you go.
Khả năng tự phục vụ (On-demand self-service).
Chia sẻ tài nguyên (Resource pooling).
4 mô hình dịch vụ (mô hình sản phẩm): cũng sẽ giải thích chi tiết hơn trong bài viết cụ thể

Public Cloud: Đám mây công cộng (là các dịch vụ trên nền tảng Cloud Computing để cho các cá nhân và tổ chức thuê, họ dùng chung tài nguyên).
Private Cloud: Đám mây riêng (dùng trong một doanh nghiệp và không chia sẻ với người dùng ngoài doanh nghiệp đó)
Community Cloud: Đám mây cộng đồng (là các dịch vụ trên nền tảng Cloud computing do các công ty cùng hợp tác xây dựng và cung cấp các dịch vụ cho cộng đồng. Tôi cũng chưa rõ FB có phải là một dạng này không, cần xác nhận lại.
Hybrid Cloud : Là mô hình kết hợp (lai) giữa các mô hình Public Cloud và Private Cloud (không rõ có Community Cloud nữa không … :D)
3 mô hình triển khai: tức là triển khai Cloud Computing để cung cấp:

Hạ tầng như một dịch vụ (Infrastructure as a Service)
Nền tảng như một dịch vụ (Platform as a Service)
Phần mềm như một dịch vụ (Software as a Service)
## 10. Launch máy ảo

**Provider network**

- Tạo provider network

``` sh
. admin-openrc
openstack network create  --share --external --provider-physical-network provider --provider-network-type flat provider
```

- Tạo subnet

``` sh
openstack subnet create --network provider \
  --allocation-pool start=192.168.100.201,end=192.168.100.250 \
  --dns-nameserver 8.8.8.8 --gateway 192.168.100.1 \
  --subnet-range 192.168.100.0/24 provider
```

**Self-service network**

- Tạo self-service network

``` sh
. demo-openrc
openstack network create selfservice
```

- Tạo subnet

``` sh
openstack subnet create --network selfservice \
  --dns-nameserver 8.8.8.8 --gateway 10.10.10.1 \
  --subnet-range 10.10.10.0/24 selfservice
```

- Tạo router

`openstack router create router`

- Thêm self-service vào interface của router

`neutron router-interface-add router selfservice`

- Set gateway của router là provider network để ra ngoài internet

`neutron router-gateway-set router provider`

- Kiểm tra lại

``` sh
ip netns
neutron router-port-list router
```

Tiến hành ping tới gateway của router để kiểm tra.

- Tạo m1.nano flavor

Flavor này chỉ dùng để test với CirrOS image

`openstack flavor create --id 0 --vcpus 1 --ram 64 --disk 1 m1.nano`

- Thêm security group rules cho phép ping và ssh

``` sh
openstack security group rule create --proto icmp default
openstack security group rule create --proto tcp --dst-port 22 default
```

- Bạn có thể truy cập vào dashboard hoặc dùng câu lệnh để tạo máy ảo

``` sh
openstack server create --flavor m1.nano --image cirros \
  --nic net-id=NET_ID --security-group default \
   provider-instance
```

Thay `NET_ID` bằng id của provider hoặc self-service network.
</pre>




