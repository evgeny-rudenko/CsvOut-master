using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Data.SqlClient;
using System.IO;

namespace CsvOut
{
    class Program
    {
        static void Main(string[] args)
        {
            if (args.Length != 2)
            {
                Console.Error.WriteLine("Usage: CsvOut sqlfile_1.sql destinationfile");
                return;
            }
            using (SqlConnection connection = new SqlConnection(Properties.Settings.Default.Connection ))
            {
                connection.Open();
                    ExportTable(connection, args[0], args[1]);                    
                
            }
        }

        private static void ExportTable(SqlConnection connection, string tableName, string fName)
        {
            fName = DateTime.Now.ToString("yyyy-MM-dd")+ "~" + Properties.Settings.Default.SubID+fName;

            Console.WriteLine("Writing " + fName );
            using (var output = new StreamWriter(Path.Combine(Properties.Settings.Default.DestinationFolder, fName) ,false, Encoding.GetEncoding("Windows-1251")  ) ) // добавить дату fname
            {
                using (var cmd = connection.CreateCommand())
                {                    
                    cmd.CommandText = File.ReadAllText(tableName);
                    using (var reader = cmd.ExecuteReader())
                    {
                        WriteHeader(reader, output);
                        while (reader.Read())
                        {
                            WriteData(reader, output);
                        }
                    }
                }
            }
        }

        
        private static void WriteHeader(SqlDataReader reader, TextWriter output)
        {
            for (int i = 0; i < reader.FieldCount; i++)
            {
                if (i > 0)
                    output.Write(';');
                output.Write(reader.GetName(i));
            }
            output.Write(';');
            output.WriteLine();
        }

        private static void WriteData(SqlDataReader reader, TextWriter output)
        {
            for (int i = 0; i < reader.FieldCount; i++)
            {
                if (i > 0)
                    output.Write(';');
                String v = reader[i].ToString();
                if (reader[i].GetType().FullName == "System.Decimal") 
                      v = v.Replace(",",".");

                if (v.Contains(';') || v.Contains('\n') || v.Contains('\r') || v.Contains('"'))
                {
                    output.Write('"');
                    output.Write(v.Replace("\"", "\"\""));
                    output.Write('"');
                }
                else
                {
                  
                    output.Write(v);
                }
            }
            output.Write(";");
            output.WriteLine();
        }
    }
}
