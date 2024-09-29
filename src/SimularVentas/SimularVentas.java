package simularventas;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.CallableStatement;

public class SimularVentas {

    public static void main(String[] args) {
        try {
            Class.forName("org.postgresql.Driver");
            Connection conexion = DriverManager.getConnection("jdbc:postgresql://localhost:5432/postgres", "postgres", "1126");
            
            CallableStatement ejecucion = conexion.prepareCall("CALL javaa.simular_ventas_mes()");                     
            ejecucion.execute();
            
           
            ejecucion.close();
            conexion.close();

            System.out.println("Ventas simuladas exitosamente.");

        } catch (Exception e) {
            System.out.println("Error: " + e.getMessage());
        }
    }
}
