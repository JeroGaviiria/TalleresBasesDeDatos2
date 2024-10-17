package taller16json;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.CallableStatement;

public class GuardarFactura {

    public static void main(String[] args) {
        try {         
            Class.forName("org.postgresql.Driver");                   
            Connection conexion = DriverManager.getConnection("jdbc:postgresql://localhost:5432/postgres", "postgres", "1126");
            
            String descripcionJson = "{" +
                    "\"nombre_cliente\": \"Jero\"," +
                    "\"identificacion\": \"123456789\"," +
                    "\"direccion_cliente\": \"Calle 123, Manizales\"," +
                    "\"codigo_factura\": \"F001\"," +
                    "\"total\": 150.75," +
                    "\"descuento\": 10.00," +
                    "\"total_factura\": 140.75," +
                    "\"productos\": [" +
                    "   {" +
                    "       \"cantidad\": 2," +
                    "       \"valor\": 50.00," +
                    "       \"producto\": {" +
                    "           \"nombre\": \"Producto A\"," +
                    "           \"descripcion\": \"Descripción del producto A\"," +
                    "           \"precio\": 50.00," +
                    "           \"categorias\": [\"categoría1\", \"categoría2\"]" +
                    "       }" +
                    "   }," +
                    "   {" +
                    "       \"cantidad\": 1," +
                    "       \"valor\": 40.75," +
                    "       \"producto\": {" +
                    "           \"nombre\": \"Producto B\"," +
                    "           \"descripcion\": \"Descripción del producto B\"," +
                    "           \"precio\": 40.75," +
                    "           \"categorias\": [\"categoría3\"]" +
                    "       }" +
                    "   }" +
                    "]" +
                "}";
            CallableStatement stmt = conexion.prepareCall("CALL taller16.guardar_factura(?, ?::jsonb)");
            
            stmt.setInt(1, 2); 
            stmt.setString(2, descripcionJson);  
            stmt.execute();

            stmt.close();
            conexion.close();

            System.out.println("Factura guardada exitosamente.");

        } catch (Exception e) {
            System.out.println("Error: " + e.getMessage());
        }
    }
}
