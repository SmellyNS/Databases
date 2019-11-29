using System;  
using System.Data.Sql;  
using Microsoft.SqlServer.Server;  
using System.Collections;  
using System.Data.SqlTypes;  
using System.Diagnostics;  

namespace pow2
{
// Класс, в котором будет реализована наша функция
    public class TableValuedFunction
    {
// Атрибут, аналогичный предыдущему случаю, но для табличной функции
// необходимо указать специальный метод для "заполнения" таблицы
        [SqlFunction(FillRowMethodName = "GenerateIntervalFillRow")]

// Сама табличная функция возвращает IEnumerable (именно его элементы и будут ходить 
// в метод-заполнитель), типы параметров желательно использовать вновь из 
// System.Data.SqlTypes
public static IEnumerable GenerateInterval(SqlInt32 To)
        {
            int[] items = new int[To.Value+1];
			int s = 1;
            for (int i = 0; i <= To.Value; i++){
				s *= 2;
				items[i] = s;
			}
            return items;
        }

        //Этот служебный метод нужен для получения одной строки набора данных и приведения её
        public static void GenerateIntervalFillRow(object o, out SqlInt32 item)
        {
            item = new SqlInt32((int)o);
        }
    }
}