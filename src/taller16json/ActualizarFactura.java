package taller16json;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.CallableStatement;

public class ActualizarFactura {

    public static void main(String[] args) {
        try {          
            Class.forName("org.postgresql.Driver");
            Connection conexion = DriverManager.getConnection("jdbc:postgresql://localhost:5432/postgres", "postgres", "1126");
       
            String nuevaDescripcionJson = "{" +
                    "\"nombre_cliente\": \"Fabian\"," +
                    "\"identificacion\": \"1234567890\"," +
                    "\"direccion_cliente\": \"Calle 456, Pereira\"," +
                    "\"codigo_factura\": \"F001\"," +
                    "\"total\": 200.75," +
                    "\"descuento\": 40.00," +
                    "\"total_factura\": 135.75," +
                    "\"productos\": [" +
                    "   {" +
                    "       \"cantidad\": 1," +
                    "       \"valor\": 100.00," +
                    "       \"producto\": {" +
                    "           \"nombre\": \"Producto A Actualizado\"," +
                    "           \"descripcion\": \"Nueva descripción del producto A\"," +
                    "           \"precio\": 100.00," +
                    "           \"categorias\": [\"categoría1\", \"categoría2\"]" +
                    "       }" +
                    "   }," +
                    "   {" +
                    "       \"cantidad\": 1," +
                    "       \"valor\": 35.75," +
                    "       \"producto\": {" +
                    "           \"nombre\": \"Producto B\"," +
                    "           \"descripcion\": \"Descripción del producto B\"," +
                    "           \"precio\": 35.75," +
                    "           \"categorias\": [\"categoría3\"]" +
                    "       }" +
                    "   }" +
                    "]" +
                "}";

            CallableStatement stmt = conexion.prepareCall("CALL taller16.actualizar_factura(?, ?::jsonb)");
            stmt.setInt(1, 1);  
            stmt.setString(2, nuevaDescripcionJson);  
            
            stmt.execute();       
            stmt.close();
            conexion.close();

            System.out.println("Factura actualizada exitosamente.");

        } catch (Exception e) {
            System.out.println("Error: " + e.getMessage());
        }
    }
}
