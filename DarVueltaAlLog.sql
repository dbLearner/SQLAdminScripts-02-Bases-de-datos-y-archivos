Create table DummyTrans(dummykey float, dummycol char(8000))

DECLARE @MaxMinutos INT
SELECT  @MaxMinutos = 2
DECLARE @HoraInicio DATETIME
SELECT  @HoraInicio = GETDATE()

WHILE     @MaxMinutos > DATEDIFF (mi, @HoraInicio, GETDATE())
  BEGIN 
     INSERT DummyTrans
     Select rand(), replicate('A', 8000)
     --DELETE DummyTrans

  END

drop table DummyTrans