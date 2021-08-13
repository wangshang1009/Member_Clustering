select count(distinct(buyer_id)) from order_info 
where date_format(date_add(create_time,interval 8 hour),'%Y%m%d') between 20210101 and 20210630
and Order_Status in (1,2);
#202106 7237
#20210406 11403---11403-7237 = 4,116(代表45兩個月有下單的會員)
#20210106 13432 13432-7237-4116 = 2,079(代表123三個月有下單的會員)

select count(member_id) from member where enabled = 1; #Total member = 368209

select count(member_id) from member 
#202101~06 login member = 73842 其中有登入的會員裡面有48442位會員是今年加入的
where date_format(date_add(Last_Login_Time,interval 8 hour),'%Y%m%d') between 20210101 and 20210630
and date_format(date_add(create_time,interval 8 hour),'%Y%m%d') between 20210101 and 20210630
and enabled = 1;

#169,374,842是今年上半年總業績 其中的41,179,905為今年註冊新會員所貢獻佔比24% 非今年新增會員貢獻128,194,937占比76%
select sum(order_item.net_amount) from order_item 
join order_info on order_info.order_id = order_item.order_id
where date_format(date_add(order_item.create_time,interval 8 hour),'%Y%m%d') between 20210101 and 20210630
and order_item.order_status in (1,2)
and order_info.buyer_id not in (
select member_id from member
where date_format(date_add(create_time,interval 8 hour),'%Y%m%d') between 20210101 and 20210630
);
#今年上半年營業額由21030會員產生 其中9687位會員是今年新加入的
select count(buyer_id) from order_info
join member on member.member_id = order_info.buyer_id
where date_format(date_add(order_info.create_time,interval 8 hour),'%Y%m%d') between 20210101 and 20210630
and date_format(date_add(member.create_time,interval 8 hour),'%Y%m%d') between 20210101 and 20210630
and order_status in (1,2);

#鍾先生營業額
select sum(net_amount) from order_info where buyer_id in (641226,641469)
and order_status in (1,2)
and date_format(date_add(create_time,interval 8 hour),'%Y%m%d') between 20210101 and 20210630;

select supplier.name,product.prod_id,product.name,product.enabled from product 
join supplier on supplier.supp_id = product.Supp_Id
where product.name like '%《團》%';

select member_behavior.member_id,Behavior_Type,member_behavior.prod_id,product.name from member_behavior 
join product on product.prod_id = member_behavior.prod_id
where member_id in (
select buyer_id from order_info
join member on member.member_id = order_info.buyer_id
where date_format(date_add(order_info.create_time,interval 8 hour),'%Y%m%d') between 20210101 and 20210630
and date_format(date_add(member.create_time,interval 8 hour),'%Y%m%d') between 20210101 and 20210630
and order_status in (1,2)
);



