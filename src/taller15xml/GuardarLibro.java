package taller15xml;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.CallableStatement;

public class GuardarLibro {
    public static void main(String[] args) {
        try {
            Class.forName("org.postgresql.Driver");
            Connection conexion = DriverManager.getConnection("jdbc:postgresql://localhost:5432/postgres", "postgres", "1126");
            
            CallableStatement stmt = conexion.prepareCall("CALL taller15.guardar_libro(?, ?, ?, ?)");
            stmt.setLong(1, 97812345678900L);
            stmt.setString(2, "Prueba1");
            stmt.setString(3, "Prueba2");
            stmt.setInt(4, 1660);
            stmt.execute();

            stmt.close();
            conexion.close();

            System.out.println("Libro guardado exitosamente.");
        } catch (Exception e) {
            System.out.println("Error: " + e.getMessage());
        }
    }
}
