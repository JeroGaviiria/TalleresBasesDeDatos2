package taller16json;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.CallableStatement;
import java.sql.ResultSet;

public class ObtenerNombreCliente {

    public static void main(String[] args) {
        try {
            Class.forName("org.postgresql.Driver");
            Connection conexion = DriverManager.getConnection("jdbc:postgresql://localhost:5432/postgres", "postgres", "1126");

            CallableStatement stmt = conexion.prepareCall("SELECT taller16.obtener_nombre_cliente(?)");
            stmt.setString(1, "1234567890");        
            ResultSet resultado = stmt.executeQuery();

            if (resultado.next()) {
                String nombreCliente = resultado.getString(1);
                System.out.println("Nombre del cliente: " + nombreCliente);
            }

            resultado.close();
            stmt.close();
            conexion.close();

        } catch (Exception e) {
            System.out.println("Error: " + e.getMessage());
        }
    }
}
