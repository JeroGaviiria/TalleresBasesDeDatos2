package taller15xml;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.CallableStatement;

public class ActualizarLibro {
    public static void main(String[] args) {
        try {
            Class.forName("org.postgresql.Driver");
            Connection conexion = DriverManager.getConnection("jdbc:postgresql://localhost:5432/postgres", "postgres", "1126");
            
            CallableStatement stmt = conexion.prepareCall("CALL taller15.actualizar_libro(?, ?, ?, ?)");
            stmt.setLong(1, 9780131103627L); // ISBN
            stmt.setString(2, "El Quijote 2"); // Título
            stmt.setString(3, "Miguel de Cervantes 2"); // Autor
            stmt.setInt(4, 1407); // Año
            stmt.execute();

            stmt.close();
            conexion.close();

            System.out.println("Libro actualizado exitosamente.");
        } catch (Exception e) {
            System.out.println("Error: " + e.getMessage());
        }
    }
}
