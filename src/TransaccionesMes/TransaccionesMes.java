package transaccionesmes;

import java.sql.*;

public class TransaccionesMes {

    public static void main(String[] args) {
        try {
            Class.forName("org.postgresql.Driver");
            Connection conexion = DriverManager.getConnection("jdbc:postgresql://localhost:5432/postgres", "postgres", "1126");

            CallableStatement ejecucion1 = conexion.prepareCall("CALL javaf.poblar_bd_simplificado()");
            ejecucion1.execute();
            ejecucion1.close();
            
            CallableStatement ejecucion2 = conexion.prepareCall("{? = call javaf.transacciones_total_mes(?, ?)}");
            ejecucion2.registerOutParameter(1, Types.NUMERIC);
            ejecucion2.setInt(2, 7); 
            ejecucion2.setInt(3, 12); 
            ejecucion2.execute();

            
            ejecucion2.close();

            conexion.close();

        } catch (Exception e) {
            System.out.println(e.getMessage());
        }
    }
}
