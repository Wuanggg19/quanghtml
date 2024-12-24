use Northwind

--1.  Liệt kê danh sách các orders ứng với tổng tiền của từng hóa đơn. Thông tin 
--bao gồm OrderID, OrderDate, Total. Trong đó Total là Sum của Quantity * 
--Unitprice, kết nhóm theo OrderID.
select O.OrderID, OrderDate, Total = sum(Quantity * Unitprice)
from Orders O join [Order Details] OD on O.OrderID = OD.OrderID
group by O.OrderID, OrderDate

--2.  Liệt kê danh sách các orders  mà địa chỉ nhận hàng ở  thành phố    ‘Madrid’
--(Shipcity). Thông tin bao gồm OrderID, OrderDate, Total. Trong đó Total
--là tổng trị giá hóa đơn, kết nhóm theo OrderID. 
select O.OrderID, OrderDate, Total = sum(Quantity * Unitprice)
from Orders O join [Order Details] OD on O.OrderID = OD.OrderID
where ShipCity = 'Madrid'
group by O.OrderID, OrderDate

--3.  Viết các truy vấn để thống kê số lượng các hóa đơn : 
---  Trong mỗi năm. Thông tin hiển thị : Year , CoutOfOrders ?
select Year(OrderDate) as Nam, CoutOfOrders = Count(OrderID)
from Orders
group by Year(OrderDate) 

---  Thông  tin  hiển  thị  :  Year  ,  Month, 
--CoutOfOrders ?
select Year(OrderDate) as Nam, Month(OrderDate) as Thang, CoutOfOrders = Count(OrderID)
from Orders
group by Year(OrderDate), Month(OrderDate)

---  Trong mỗi tháng/năm và ứng với mỗi nhân viên. Thông tin hiển 
--thị : Year, Month, EmployeeID, CoutOfOrders ?
select Year(OrderDate) as Nam, Month(OrderDate) as Thang, E.EmployeeID, CoutOfOrders = Count(*)
from Orders O join Employees E on O.EmployeeID = E.EmployeeID
group by Year(OrderDate), Month(OrderDate),E.EmployeeID

--4.  Cho  biết  mỗi  Employee  đã  lập  bao  nhiêu  hóa  đơn.  Thông  tin  gồm 
--EmployeeID,  EmployeeName,  CountOfOrder. Trong đó CountOfOrder là 
--tổng  số  hóa  đơn  của  từng  employee.  EmployeeName  được  ghép  từ 
--LastName và FirstName.
select E.EmployeeID,  EmployeeName = E.FirstName + ' ' + E.LastName, CountOfOrder = Count(*)
from Employees E join Orders O on E.EmployeeID = O.EmployeeID
group by E.EmployeeID,  E.FirstName + ' ' + E.LastName

--5.  Cho biết mỗi Employee đã  lập được bao nhiêu hóa đơn, ứng với tổng tiền
--các  hóa  đơn  tương  ứng.  Thông  tin  gồm  EmployeeID,  EmployeeName, 
--CountOfOrder , Total.
select E.EmployeeID,  EmployeeName = E.FirstName + ' ' + E.LastName,  CountOfOrder = Count(*) , Total = sum(OD.Quantity * OD.UnitPrice)
from Employees E join Orders O on E.EmployeeID = O.EmployeeID 
				 join [Order Details] OD on O.OrderID = OD.OrderID
group by E.EmployeeID,  E.FirstName + ' ' + E.LastName
				  
--6.  Liệt  kê  bảng  lương  của  mỗi  Employee  theo  từng  tháng  trong  năm  1996 
--gồm  EmployeeID,  EmployName,  Month_Salary,  Salary  = 
--sum(quantity*unitprice)*10%.  Được  sắp  xếp  theo  Month_Salary,  cùmg 
--Month_Salary thì sắp xếp theo Salary giảm dần.
select E.EmployeeID,  EmployeeName = E.FirstName + ' ' + E.LastName,  Month(O.OrderDate) as Month_Salary, sum(OD.Quantity*OD.UnitPrice)* 0.1 as Salary
from Employees E join Orders O on E.EmployeeID = O.EmployeeID 
				 join [Order Details] OD on O.OrderID = OD.OrderID
where Year(O.OrderDate) = 1996
group by E.EmployeeID,  E.FirstName + ' ' + E.LastName, Month(O.OrderDate)
order by Month_Salary, Salary DESC;

--7.  Tính tổng số hóa đơn và tổng tiền các hóa đơn  của mỗi nhân viên đã bán 
--trong  tháng  3/1997,  có  tổng  tiền  >4000.  Thông  tin  gồm  EmployeeID, 
--LastName, FirstName, CountofOrder, Total. 
select E.EmployeeID,  LastName, FirstName,  CountOfOrder = Count(*) , Total = sum(OD.Quantity * OD.UnitPrice)
from Employees E join Orders O on E.EmployeeID = O.EmployeeID 
				 join [Order Details] OD on O.OrderID = OD.OrderID
where Month(O.OrderDate) = 3 and Year(O.OrderDate) = 1997
group by E.EmployeeID,  E.FirstName, E.LastName
having sum(OD.Quantity * OD.UnitPrice) > 4000

--8.  Liệt kê danh sách các customer ứng với tổng số hoá đơn, tổng tiền các hoá 
--đơn, mà các hóa đơn được lập từ 31/12/1996 đến 1/1/1998 và tổng tiền các 
--hóa  đơn  >20000.  Thông  tin  được  sắp  xếp  theo  CustomerID,  cùng  mã  thì 
--sắp xếp theo tổng tiền giảm dần.
select C.CustomerID, count(O.OrderID) as TongHD, sum(OD.Quantity * OD.UnitPrice) as TongTien
from Customers C join Orders O on C.CustomerID = O.CustomerID
				 join [Order Details] OD on OD.OrderID = O.OrderID
where O.OrderDate BETWEEN '1996-12-31' AND '1998-01-01'
group by  C.CustomerID
HAVING  SUM(OD.Quantity * OD.UnitPrice) > 20000
ORDER BY 
    C.CustomerID,
    TongTien DESC;

--9.  Liệt kê danh sách các customer ứng với tổng tiền của các hóa đơn ở từng 
--tháng.  Thông  tin  bao  gồm  CustomerID,  CompanyName,  Month_Year, 
--Total. Trong đó Month_year là tháng và năm lập hóa đơn, Total là tổng của 
--Unitprice* Quantity.
select C.CustomerID, month(O.OrderDate), (O.OrderID) as TongHD, sum(OD.Quantity * OD.UnitPrice) as TongTien
from Customers C join Orders O on C.CustomerID = O.CustomerID
				 join [Order Details] OD on OD.OrderID = O.OrderID
group by  C.CustomerID
HAVING  SUM(OD.Quantity * OD.UnitPrice) > 20000
ORDER BY C.CustomerID, TongTien DESC;

--10.  Liệt  kê  danh  sách  các  nhóm  hàng  (category)  có  tổng  số  lượng  tồn 
--(UnitsInStock) lớn hơn 300, đơn giá trung bình nhỏ hơn 25. Thông tin bao 
--gồm CategoryID, CategoryName, Total_UnitsInStock, Average_Unitprice.

--11.  Liệt kê danh sách các  nhóm hàng (category)  có tổng số mặt hàng  (product)
--nhỏ  hớn  10.  Thông  tin  kết  quả  bao  gồm  CategoryID,  CategoryName, 
--CountOfProducts.  Được sắp xếp theo CategoryName, cùng  CategoryName
--thì sắp theo CountOfProducts giảm dần.

--12.  Liệt kê danh sách các Product  bán trong  quý 1 năm 1998 có tổng số lượng 
--bán ra >200, thông tin gồm [ProductID], [ProductName], SumofQuatity 

--13.  Cho biết Employee nào bán được nhiều tiền nhất trong tháng 7 năm 1997
	select top 1 with ties E.EmployeeID,  LastName, FirstName, Total = sum(OD.Quantity * OD.UnitPrice)
	from Employees E join Orders O on E.EmployeeID = O.EmployeeID
	join [Order Details] OD on OD.OrderID = O.OrderID
	where month(O.OrderDate) = 7 and year(O.OrderDate) = 1997
	group by E.EmployeeID,  LastName, FirstName
	order by Total desc

	--c2
	select E.EmployeeID,  LastName, FirstName, Total = sum(OD.Quantity * OD.UnitPrice)
	from Employees E join Orders O on E.EmployeeID = O.EmployeeID
	join [Order Details] OD on OD.OrderID = O.OrderID
	where month(O.OrderDate) = 7 and year(O.OrderDate) = 1997
	group by E.EmployeeID,  LastName, FirstName
	having sum(OD.Quantity * OD.UnitPrice) >= all(
		select sum(OD.Quantity * OD.UnitPrice)
		from Employees E join Orders O on E.EmployeeID = O.EmployeeID
		join [Order Details] OD on OD.OrderID = O.OrderID
		where month(O.OrderDate) = 7 and year(O.OrderDate) = 1997
		group by E.EmployeeID,  LastName, FirstName
	)
--14.  Liệt kê danh sách 3 Customer có nhiều đơn hàng nhất của năm 1996.

--15.  Liệt  kê  danh  sách  các  Products  có  tổng  số  lượng  lập  hóa  đơn  lớn  nhất.
--Thông tin gồm ProductID, ProductName, CountOfOrders