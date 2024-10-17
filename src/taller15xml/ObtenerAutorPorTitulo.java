package taller15xml;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

public class ObtenerAutorPorTitulo {
    public static void main(String[] args) {
        try {
            Class.forName("org.postgresql.Driver");
            Connection conexion = DriverManager.getConnection("jdbc:postgresql://localhost:5432/postgres", "postgres", "1126");

            PreparedStatement stmt = conexion.prepareStatement("SELECT taller15.obtener_autor_libro_por_titulo(?)");
            stmt.setString(1, "Old News"); 
            
            ResultSet rs = stmt.executeQuery();
            
            if (rs.next()) {
                String autor = rs.getString(1);
                System.out.println("Autor del libro: " + autor);
            } else {
                System.out.println("No se encontro un autor para el titulo proporcionado.");
            }

            rs.close();
            stmt.close();
            conexion.close();
            
        } catch (Exception e) {
            System.out.println("Error: " + e.getMessage());
        }
    }
}
