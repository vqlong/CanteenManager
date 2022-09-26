USE [master]
GO
/****** Object:  Database [CanteenManager]    Script Date: 9/26/2022 8:32:52 PM ******/
CREATE DATABASE [CanteenManager]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'CanteenManager', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL15.SQLEXPRESS\MSSQL\DATA\CanteenManager.mdf' , SIZE = 3584KB , MAXSIZE = UNLIMITED, FILEGROWTH = 65536KB )
 LOG ON 
( NAME = N'CanteenManager_log', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL15.SQLEXPRESS\MSSQL\DATA\CanteenManager_log.ldf' , SIZE = 3976KB , MAXSIZE = 2048GB , FILEGROWTH = 65536KB )
 WITH CATALOG_COLLATION = DATABASE_DEFAULT
GO
ALTER DATABASE [CanteenManager] SET COMPATIBILITY_LEVEL = 150
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [CanteenManager].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [CanteenManager] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [CanteenManager] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [CanteenManager] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [CanteenManager] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [CanteenManager] SET ARITHABORT OFF 
GO
ALTER DATABASE [CanteenManager] SET AUTO_CLOSE ON 
GO
ALTER DATABASE [CanteenManager] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [CanteenManager] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [CanteenManager] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [CanteenManager] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [CanteenManager] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [CanteenManager] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [CanteenManager] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [CanteenManager] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [CanteenManager] SET  ENABLE_BROKER 
GO
ALTER DATABASE [CanteenManager] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [CanteenManager] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [CanteenManager] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [CanteenManager] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [CanteenManager] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [CanteenManager] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [CanteenManager] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [CanteenManager] SET RECOVERY SIMPLE 
GO
ALTER DATABASE [CanteenManager] SET  MULTI_USER 
GO
ALTER DATABASE [CanteenManager] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [CanteenManager] SET DB_CHAINING OFF 
GO
ALTER DATABASE [CanteenManager] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [CanteenManager] SET TARGET_RECOVERY_TIME = 60 SECONDS 
GO
ALTER DATABASE [CanteenManager] SET DELAYED_DURABILITY = DISABLED 
GO
ALTER DATABASE [CanteenManager] SET ACCELERATED_DATABASE_RECOVERY = OFF  
GO
ALTER DATABASE [CanteenManager] SET QUERY_STORE = OFF
GO
USE [CanteenManager]
GO
/****** Object:  User [admin]    Script Date: 9/26/2022 8:32:52 PM ******/
CREATE USER [admin] FOR LOGIN [admin] WITH DEFAULT_SCHEMA=[dbo]
GO
ALTER ROLE [db_owner] ADD MEMBER [admin]
GO
/****** Object:  UserDefinedFunction [dbo].[UF_ConvertToUnsigned]    Script Date: 9/26/2022 8:32:52 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--Convert có dấu thành không dấu
CREATE FUNCTION [dbo].[UF_ConvertToUnsigned] ( @strInput NVARCHAR(4000) ) 
RETURNS NVARCHAR(4000) 
AS 
BEGIN 
	IF @strInput IS NULL RETURN @strInput 
	IF @strInput = '' RETURN @strInput 
	DECLARE @RT NVARCHAR(4000) 
	DECLARE @SIGN_CHARS NCHAR(136) 
	DECLARE @UNSIGN_CHARS NCHAR (136) 
	SET @SIGN_CHARS = N'ăâđêôơưàảãạáằẳẵặắầẩẫậấèẻẽẹéềểễệế ìỉĩịíòỏõọóồổỗộốờởỡợớùủũụúừửữựứỳỷỹỵý ĂÂĐÊÔƠƯÀẢÃẠÁẰẲẴẶẮẦẨẪẬẤÈẺẼẸÉỀỂỄỆẾÌỈĨỊÍ ÒỎÕỌÓỒỔỖỘỐỜỞỠỢỚÙỦŨỤÚỪỬỮỰỨỲỶỸỴÝ' +NCHAR(272)+ NCHAR(208) 
	SET @UNSIGN_CHARS = N'aadeoouaaaaaaaaaaaaaaaeeeeeeeeee iiiiiooooooooooooooouuuuuuuuuuyyyyy AADEOOUAAAAAAAAAAAAAAAEEEEEEEEEEIIIII OOOOOOOOOOOOOOOUUUUUUUUUUYYYYYDD' 
	DECLARE @COUNTER int 
	DECLARE @COUNTER1 int 
	SET @COUNTER = 1 
	WHILE (@COUNTER <=LEN(@strInput)) 
		BEGIN 
			SET @COUNTER1 = 1 
			WHILE (@COUNTER1 <=LEN(@SIGN_CHARS)+1) 
				BEGIN 
					IF UNICODE(SUBSTRING(@SIGN_CHARS, @COUNTER1,1)) = UNICODE(SUBSTRING(@strInput,@COUNTER ,1) ) 
						BEGIN 
							IF @COUNTER=1 
								SET @strInput = SUBSTRING(@UNSIGN_CHARS, @COUNTER1,1) + SUBSTRING(@strInput, @COUNTER+1,LEN(@strInput)-1) 
							ELSE 
								SET @strInput = SUBSTRING(@strInput, 1, @COUNTER-1) +SUBSTRING(@UNSIGN_CHARS, @COUNTER1,1) + SUBSTRING(@strInput, @COUNTER+1,LEN(@strInput)- @COUNTER) 
							BREAK 
						END 
					SET @COUNTER1 = @COUNTER1 +1 
				END 
			SET @COUNTER = @COUNTER +1 
		END 
		SET @strInput = replace(@strInput,' ','-') 
		RETURN @strInput 
END
GO
/****** Object:  Table [dbo].[Account]    Script Date: 9/26/2022 8:32:52 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Account](
	[UserName] [nvarchar](100) NOT NULL,
	[DisplayName] [nvarchar](100) NOT NULL,
	[PassWord] [nvarchar](1000) NOT NULL,
	[AccType] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[UserName] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Bill]    Script Date: 9/26/2022 8:32:52 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Bill](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[DateCheckIn] [datetime] NOT NULL,
	[DateCheckOut] [datetime] NULL,
	[TableID] [int] NOT NULL,
	[BillStatus] [int] NOT NULL,
	[Discount] [int] NOT NULL,
	[TotalPrice] [float] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[BillInfo]    Script Date: 9/26/2022 8:32:52 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[BillInfo](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[BillID] [int] NOT NULL,
	[FoodID] [int] NOT NULL,
	[FoodCount] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Food]    Script Date: 9/26/2022 8:32:52 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Food](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](100) NOT NULL,
	[CategoryID] [int] NOT NULL,
	[Price] [float] NOT NULL,
	[FoodStatus] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[FoodCategory]    Script Date: 9/26/2022 8:32:52 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[FoodCategory](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](100) NOT NULL,
	[CategoryStatus] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[TableFood]    Script Date: 9/26/2022 8:32:52 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TableFood](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](100) NOT NULL,
	[TableStatus] [nvarchar](100) NOT NULL,
	[UsingState] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Account] ADD  DEFAULT (N'CafeNo1') FOR [DisplayName]
GO
ALTER TABLE [dbo].[Account] ADD  DEFAULT (N'952362351022552001115621782120108109105108121194219194572217814518010341215583925187233') FOR [PassWord]
GO
ALTER TABLE [dbo].[Account] ADD  DEFAULT ((0)) FOR [AccType]
GO
ALTER TABLE [dbo].[Bill] ADD  DEFAULT (getdate()) FOR [DateCheckIn]
GO
ALTER TABLE [dbo].[Bill] ADD  DEFAULT ((0)) FOR [BillStatus]
GO
ALTER TABLE [dbo].[Bill] ADD  DEFAULT ((0)) FOR [Discount]
GO
ALTER TABLE [dbo].[Bill] ADD  DEFAULT ((0)) FOR [TotalPrice]
GO
ALTER TABLE [dbo].[BillInfo] ADD  DEFAULT ((0)) FOR [FoodCount]
GO
ALTER TABLE [dbo].[Food] ADD  DEFAULT (N'Chưa đặt tên') FOR [Name]
GO
ALTER TABLE [dbo].[Food] ADD  DEFAULT ((0)) FOR [Price]
GO
ALTER TABLE [dbo].[Food] ADD  DEFAULT ((1)) FOR [FoodStatus]
GO
ALTER TABLE [dbo].[FoodCategory] ADD  DEFAULT (N'Chưa đặt tên') FOR [Name]
GO
ALTER TABLE [dbo].[FoodCategory] ADD  DEFAULT ((1)) FOR [CategoryStatus]
GO
ALTER TABLE [dbo].[TableFood] ADD  DEFAULT (N'Chưa đặt tên') FOR [Name]
GO
ALTER TABLE [dbo].[TableFood] ADD  DEFAULT (N'Trống') FOR [TableStatus]
GO
ALTER TABLE [dbo].[TableFood] ADD  DEFAULT ((1)) FOR [UsingState]
GO
ALTER TABLE [dbo].[Bill]  WITH CHECK ADD FOREIGN KEY([TableID])
REFERENCES [dbo].[TableFood] ([ID])
GO
ALTER TABLE [dbo].[BillInfo]  WITH CHECK ADD FOREIGN KEY([BillID])
REFERENCES [dbo].[Bill] ([ID])
GO
ALTER TABLE [dbo].[BillInfo]  WITH CHECK ADD FOREIGN KEY([FoodID])
REFERENCES [dbo].[Food] ([ID])
GO
ALTER TABLE [dbo].[Food]  WITH CHECK ADD FOREIGN KEY([CategoryID])
REFERENCES [dbo].[FoodCategory] ([ID])
GO
/****** Object:  StoredProcedure [dbo].[USP_CheckOut]    Script Date: 9/26/2022 8:32:52 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--proc thanh toán Bill
CREATE PROC [dbo].[USP_CheckOut]
@billID INT,
@discount INT,
@totalPrice FLOAT
AS
BEGIN
	--Khi Bill được thanh toán => BillStatus = 1
	UPDATE Bill SET BillStatus = 1, DateCheckOut = GETDATE(), Discount = @discount, TotalPrice = @totalPrice  WHERE ID = @billID

	--DECLARE @tableID INT
	--Theo thiết kế mỗi Bill chỉ có 1 ID duy nhất => kết quả trả về luôn chỉ có 1 hàng => Dùng hàm MAX/MIN để lấy được TableID của Bill
	--SELECT @tableID = MAX(Bill.TableID) FROM Bill WHERE Bill.ID = @billID
	--Khi 1 bàn được thanh toán Bill, nó sẽ chuyển sang trạng thái 'Trống'
	--UPDATE TableFood SET TableStatus = N'Trống' WHERE TableFood.ID = @tableID
END
GO
/****** Object:  StoredProcedure [dbo].[USP_CombineTable]    Script Date: 9/26/2022 8:32:52 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--Proc gộp bàn thứ 1 vào bàn thứ 2
CREATE PROC [dbo].[USP_CombineTable]
@firstTableID INT,
@secondTableID INT
AS
BEGIN
    DECLARE @firstBillID INT = 0
    DECLARE @secondBillID INT = 0
    DECLARE @result INT = 0
    --Lấy ra BillID của Bill chưa thanh toán trên 2 bàn cần gộp vào nhau
    SELECT @firstBillID = Bill.ID FROM Bill WHERE TableID = @firstTableID AND BillStatus = 0
    SELECT @secondBillID = Bill.ID FROM Bill WHERE TableID = @secondTableID AND BillStatus = 0

    --Nếu 2 bàn đều có người thì mới tiến hành gộp
    IF(@firstBillID != 0 AND @secondBillID != 0)
        BEGIN
            --Gộp bàn thứ 1 vào bàn thứ 2 bằng cách thay BillID trong bảng BillInfo
            UPDATE BillInfo SET BillID = @secondBillID WHERE BillID = @firstBillID
            SET @result = 1

            --Khi gộp bàn sẽ xuất hiện các món trùng lặp với nhau
            --Tạo con trỏ và lấy ra các FoodID với số lần trùng lặp
            DECLARE BillInfoCursor CURSOR FOR SELECT FoodID, count(*) AS 'Count' FROM BillInfo WHERE BillID = @secondBillID GROUP BY FoodID
            OPEN BillInfoCursor

            DECLARE @foodID INT
            DECLARE @count INT

            FETCH NEXT FROM BillInfoCursor INTO @foodID, @count

            WHILE @@FETCH_STATUS = 0
                BEGIN
                    --Trường hợp @count > 1 tức là món này bị trùng nhau, xuất hiện hơn 1 lần
                    IF(@count > 1) 
                        BEGIN
                            DECLARE @finalFoodCount INT = 0
                            --Tính gộp tổng các FoodCount của món này
                            SELECT @finalFoodCount = SUM(FoodCount) FROM BillInfo WHERE BillID = @secondBillID AND FoodID = @foodID
            
                            DECLARE @maxID INT = 0
                            --Lấy ra max ID của món này để tí nữa giữ lại, các ID khác xoá hết cho khỏi trùng nhau
                            SELECT @maxID = MAX(ID) FROM BillInfo WHERE BillID = @secondBillID AND FoodID = @foodID

                            --update số lượng món ăn cho ID này
                            UPDATE BillInfo SET FoodCount = @finalFoodCount WHERE BillID = @secondBillID AND FoodID = @foodID AND ID = @maxID --Cài nhiều điều kiện cho chắc kèo

                            --Xoá các ID còn lại
                            DELETE BillInfo WHERE BillID = @secondBillID AND FoodID = @foodID AND ID != @maxID
            
                        END

                    FETCH NEXT FROM BillInfoCursor INTO @foodID, @count
                END

            CLOSE BillInfoCursor
            DEALLOCATE BillInfoCursor

        END

    SELECT @result
END
GO
/****** Object:  StoredProcedure [dbo].[USP_GetListBillByDate]    Script Date: 9/26/2022 8:32:52 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--Proc lấy danh sách các hoá đơn dựa theo ngày truyền vào
CREATE PROC [dbo].[USP_GetListBillByDate]
@fromDate DATETIME,
@toDate DATETIME
AS
BEGIN
	SELECT 
	Bill.ID, 
	Bill.DateCheckIn AS [Ngày phát sinh], 
	Bill.DateCheckOut AS [Ngày thanh toán], 
	TableFood.Name AS [Tên bàn], 
	Bill.Discount AS [Giảm giá (%)], 
	Bill.TotalPrice AS [Tiền thanh toán (Vnđ)]
	FROM Bill, TableFood 
	WHERE DateCheckIn >= @fromDate AND DateCheckOut <= @toDate AND BillStatus = 1 AND TableFood.ID = Bill.TableID
END
GO
/****** Object:  StoredProcedure [dbo].[USP_GetListBillByDateAndPage]    Script Date: 9/26/2022 8:32:52 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--Proc lấy danh sách các hoá đơn dựa theo ngày và số trang truyền vào
CREATE PROC [dbo].[USP_GetListBillByDateAndPage]
@fromDate DATETIME,
@toDate DATETIME,
@pageNumber INT = 1, --Page muốn lấy về
@pageRow INT = 10 --Số dòng 1 page
AS
BEGIN
	DECLARE @totalRow INT = (SELECT COUNT(*) FROM Bill WHERE DateCheckIn >= @fromDate AND DateCheckOut <= @toDate AND BillStatus = 1) --Lấy tổng số dòng thoả mãn ngày truyền vào
	DECLARE @selectRow INT = @pageNumber * @pageRow --Lấy số dòng chứa page cần lấy
	DECLARE @exceptRow INT = (@pageNumber - 1) * @pageRow; --Lấy số dòng sẽ loại trừ ra bằng EXCEPT
	
	--IF @exceptRow < @totalRow
		--BEGIN
			WITH temp AS
			(
				SELECT 
				Bill.ID, 
				Bill.DateCheckIn AS [Ngày phát sinh], 
				Bill.DateCheckOut AS [Ngày thanh toán], 
				TableFood.Name AS [Tên bàn], 
				Bill.Discount AS [Giảm giá (%)], 
				Bill.TotalPrice AS [Tiền thanh toán (Vnđ)]
				FROM Bill, TableFood 
				WHERE DateCheckIn >= @fromDate AND DateCheckOut <= @toDate AND BillStatus = 1 AND TableFood.ID = Bill.TableID
			)
			SELECT TOP (@selectRow) * FROM temp 
			EXCEPT 
			SELECT TOP (@exceptRow) * FROM temp
		--END
END
GO
/****** Object:  StoredProcedure [dbo].[USP_GetListTable]    Script Date: 9/26/2022 8:32:52 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--proc lấy danh sách bàn ăn
CREATE PROC [dbo].[USP_GetListTable]
AS
SELECT * FROM dbo.TableFood
GO
/****** Object:  StoredProcedure [dbo].[USP_GetListTableUsing]    Script Date: 9/26/2022 8:32:52 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--proc lấy danh sách bàn ăn trong trạng thái còn sử dụng
CREATE PROC [dbo].[USP_GetListTableUsing]
AS
SELECT * FROM TableFood WHERE UsingState = 1
GO
/****** Object:  StoredProcedure [dbo].[USP_GetMenu]    Script Date: 9/26/2022 8:32:52 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[USP_GetMenu]
AS
	SET NOCOUNT ON;
SELECT        Food.Name AS Món, FoodCategory.Name AS Mục, Food.Price AS Giá
FROM            Food INNER JOIN
                         FoodCategory ON Food.CategoryID = FoodCategory.ID
GO
/****** Object:  StoredProcedure [dbo].[USP_GetRevenueByFoodAndDate]    Script Date: 9/26/2022 8:32:52 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--Proc lấy tổng doanh thu (chưa tính giảm giá) của từng món ăn dựa theo ngày truyền vào
CREATE PROCEDURE [dbo].[USP_GetRevenueByFoodAndDate]
@fromDate DATETIME,
@toDate DATETIME
AS
BEGIN
	WITH temp AS
	(
		SELECT BillInfo.ID, BillID, FoodID, Name, FoodCount, Price, FoodCount * Price AS [TotalPrice], DateCheckIn, DateCheckOut 
		FROM dbo.BillInfo 
		JOIN dbo.Food ON Food.ID = BillInfo.FoodID
		JOIN dbo.Bill ON Bill.ID = BillInfo.BillID AND BillStatus = 1 AND DateCheckIn >= @fromDate AND DateCheckOut <= @toDate
	
	)
	SELECT temp.Name, SUM(temp.FoodCount) AS [TotalFoodCount], SUM(temp.TotalPrice) AS [Revenue] FROM temp GROUP BY temp.Name
END
GO
/****** Object:  StoredProcedure [dbo].[USP_GetRevenueByMonth]    Script Date: 9/26/2022 8:32:52 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--Proc lấy tổng doanh thu (đã tính giảm giá) của từng tháng dựa theo ngày truyền vào
CREATE PROCEDURE [dbo].[USP_GetRevenueByMonth]
@fromDate DATETIME,
@toDate DATETIME
AS
BEGIN
	WITH temp AS
	(
		SELECT *, CONCAT(MONTH(DateCheckOut),'-',YEAR(DateCheckOut)) AS [Month] 
		FROM dbo.Bill 
		WHERE BillStatus = 1 AND DateCheckIn >= @fromDate AND DateCheckOut <= @toDate	
	)
	SELECT temp.Month, SUM(temp.TotalPrice) AS [Revenue] FROM temp GROUP BY temp.Month
END
GO
/****** Object:  StoredProcedure [dbo].[USP_InsertBill]    Script Date: 9/26/2022 8:32:52 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--proc thêm Bill mới
--  ID: tự động thêm do ràng buộc IDENTITY
--	DateCheckIn: luôn là ngày hôm nay
--	DateCheckOut: luôn là NULL do hoá đơn mới tạo, chưa thanh toán
--	TableID: ID của bàn phát sinh hoá đơn
--	BillStatus: luôn là 0 - chưa thanh toán
--  Discount: luôn là 0 khi thêm Bill mới, sau khi thanh toán mới tính vào
CREATE PROC [dbo].[USP_InsertBill]
@tableID INT
AS
BEGIN
	--Thêm 1 Bill mới
	INSERT Bill VALUES(GETDATE(), NULL, @tableID, 0, 0, 0)
	--Khi 1 bàn có Bill mới, nó sẽ chuyển sang trạng thái 'Có người'
	--UPDATE TableFood SET TableStatus = N'Có người' WHERE TableFood.ID = @tableID
END
GO
/****** Object:  StoredProcedure [dbo].[USP_InsertBillInfo]    Script Date: 9/26/2022 8:32:52 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--proc thêm BillInfo mới
CREATE PROC [dbo].[USP_InsertBillInfo]
@billID INT,
@foodID INT,
@foodCount INT
AS
BEGIN
	DECLARE @isExistBillInfo INT
	DECLARE @currentFoodCount INT

	--Kiểm tra xem cái BillInfo này có tồn tại không (cái Bill này đã có BillInfo nào chưa, nếu có thì đã có món ăn này chưa)
	--Nếu tồn tại thì kết quả trả về cũng chỉ có 1 hàng duy nhất => Dùng hàm MAX hoặc MIN để lấy được FoodCount của món ăn
	SELECT @isExistBillInfo = COUNT(*), @currentFoodCount = MAX(FoodCount) FROM BillInfo WHERE BillInfo.BillID = @billID AND BillInfo.FoodID = @foodID

	--Nếu đã tồn tại thì update số lượng món đã gọi
	--Nếu không thì thêm mới
	IF (@isExistBillInfo > 0)
		BEGIN
			--Theo thiết kế @foodCount truyền vào có thể âm, nếu @newFoodCount <= 0 thì xoá món đó khỏi hoá đơn
			DECLARE @newFoodCount INT = @currentFoodCount + @foodCount
			IF (@newFoodCount <= 0)
				DELETE BillInfo WHERE BillInfo.BillID = @billID AND BillInfo.FoodID = @foodID
			ELSE
				UPDATE BillInfo SET FoodCount = @newFoodCount WHERE BillInfo.BillID = @billID AND BillInfo.FoodID = @foodID
		END
	ELSE
		--Nếu @foodCount > 0 (người dùng chọn số món > 0) mới thực hiện thêm
		IF (@foodCount > 0)
			BEGIN
				INSERT BillInfo VALUES(@billID, @foodID, @foodCount)
			END
	
END
GO
/****** Object:  StoredProcedure [dbo].[USP_InsertFood]    Script Date: 9/26/2022 8:32:52 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--Proc thêm món ăn cho Food
CREATE PROC [dbo].[USP_InsertFood]
@name NVARCHAR(100),
@categoryID INT,
@price FLOAT
AS
BEGIN
	INSERT Food(Name, CategoryID, Price) VALUES(@name, @categoryID, @price)
END
GO
/****** Object:  StoredProcedure [dbo].[USP_InsertTable]    Script Date: 9/26/2022 8:32:52 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--proc tạo bàn mới
CREATE PROC [dbo].[USP_InsertTable]
AS
INSERT TableFood(Name) VALUES(N'Bàn ' + CAST((SELECT COUNT(*) FROM TableFood) + 1 AS NVARCHAR(100)))
GO
/****** Object:  StoredProcedure [dbo].[USP_Login]    Script Date: 9/26/2022 8:32:52 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--proc kiểm tra thông tin đăng nhập
CREATE PROC [dbo].[USP_Login]
@UserName NVARCHAR(100),
@PassWord NVARCHAR(100)
AS
BEGIN
    SELECT UserName, DisplayName, AccType FROM dbo.Account WHERE UserName = @UserName AND PassWord = @PassWord
END
GO
/****** Object:  StoredProcedure [dbo].[USP_SwapTable]    Script Date: 9/26/2022 8:32:52 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--Proc chuyển bàn
--(bằng cách tráo đổi TableID của 2 Bill)
CREATE PROC [dbo].[USP_SwapTable]
@firstTableID INT,
@secondTableID INT
AS
BEGIN
	DECLARE @firstBillID INT = 0
	DECLARE @secondBillID INT = 0
	--Lấy ra BillID của Bill chưa thanh toán trên 2 bàn cần chuyển chỗ cho nhau
	SELECT @firstBillID = Bill.ID FROM Bill WHERE TableID = @firstTableID AND BillStatus = 0
	SELECT @secondBillID = Bill.ID FROM Bill WHERE TableID = @secondTableID AND BillStatus = 0
	
	IF(@firstBillID != 0) 
	--Nếu bàn thứ nhất được chọn có người thì mới tiến hành chuyển
		IF(@secondBillID !=0) 
		--Nếu bàn thứ hai được chọn cũng có người => tráo đổi TableID của 2 Bill cho nhau
			BEGIN
				UPDATE Bill SET TableID = @firstTableID WHERE ID = @secondBillID
				UPDATE Bill SET TableID = @secondTableID WHERE ID = @firstBillID
			END
		ELSE
		--Nếu bàn thứ hai được chọn không có người => chỉ cần thay đổi TableID của Bill
			BEGIN
				UPDATE Bill SET TableID = @secondTableID WHERE ID = @firstBillID
			END
	
END
GO
/****** Object:  StoredProcedure [dbo].[USP_UpdateAccount]    Script Date: 9/26/2022 8:32:52 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--Proc update DisplayName, PassWord và AccType cho Account
CREATE PROC [dbo].[USP_UpdateAccount]
@userName NVARCHAR(100),
@displayName NVARCHAR(100) = NULL,
@passWord NVARCHAR(100) = NULL,
@accType INT = NULL
AS
BEGIN
	UPDATE Account SET Account.DisplayName = @displayName WHERE UserName = @userName AND @displayName IS NOT NULL AND @displayName != ''
	UPDATE Account SET Account.PassWord = @passWord WHERE UserName = @userName AND @passWord IS NOT NULL AND @passWord != ''
	UPDATE Account SET Account.AccType = @accType WHERE UserName = @userName AND @accType IS NOT NULL
END
GO
/****** Object:  StoredProcedure [dbo].[USP_UpdateFood]    Script Date: 9/26/2022 8:32:52 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--Proc update món ăn cho Food
CREATE PROC [dbo].[USP_UpdateFood]
@id INT,
@name NVARCHAR(100),
@categoryID INT,
@price FLOAT,
@foodStatus INT
AS
BEGIN
	UPDATE Food SET Food.Name = @name, Food.CategoryID = @categoryID, Food.Price = @price, Food.FoodStatus = @foodStatus WHERE Food.ID = @id
END
GO
USE [master]
GO
ALTER DATABASE [CanteenManager] SET  READ_WRITE 
GO
