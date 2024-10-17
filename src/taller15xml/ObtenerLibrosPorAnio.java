package taller15xml;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

public class ObtenerLibrosPorAnio {
    public static void main(String[] args) {
        try {
            Class.forName("org.postgresql.Driver");
            Connection conexion = DriverManager.getConnection("jdbc:postgresql://localhost:5432/postgres", "postgres", "1126");

            PreparedStatement stmt = conexion.prepareStatement("SELECT * FROM taller15.obtener_libros_por_anio(?)");
            stmt.setInt(1, 1605); // Año del libro

            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                long isbn = rs.getLong("isbn");
                String titulo = rs.getString("titulo");
                String autor = rs.getString("autor");
                
                System.out.println("ISBN: " + isbn + ", Titulo: " + titulo + ", Autor: " + autor);
            }

            rs.close();
            stmt.close();
            conexion.close();

        } catch (Exception e) {
            System.out.println("Error: " + e.getMessage());
        }
    }
}
