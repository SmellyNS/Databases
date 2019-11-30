using System;  
using System.Data;  
using System.Data.SqlClient;  
using System.Data.SqlTypes;  
using Microsoft.SqlServer.Server;  
  
[Serializable]  
[SqlUserDefinedAggregate(  
    Format.Native,  
    IsInvariantToDuplicates = false,  
    IsInvariantToNulls = true,  
    IsInvariantToOrder = true,  
    IsNullIfEmpty = true,  
    Name = "Mult")]  
public struct Mult  
{  

    private long sum;  
  
    public void Init()  
    {  
        sum = 1;
    }  
  
    public void Accumulate(SqlInt32 Value)  
    {  
        if (!Value.IsNull)  
        {  
            sum *= (long)Value; 
        }  
    }  
  
    public void Merge(Mult Group)  
    {  
        sum *= Group.sum; 
    }  
    public SqlInt32 Terminate()  
    {  
 
        int value = (int)sum;  
        return new SqlInt32(value);  

    }  
}  