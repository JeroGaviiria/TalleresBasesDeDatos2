    package serviciosnopagados;

    import java.sql.*;

    public class ServiciosNoPagados {
        public static void main(String[] args) {
            try {
                Class.forName("org.postgresql.Driver");
                Connection conexion = DriverManager.getConnection("jdbc:postgresql://localhost:5432/postgres", "postgres", "1126");
                CallableStatement ejecucion = conexion.prepareCall("SELECT javaf2.servicios_no_pagados_mes(?)");

                ejecucion.setInt(1,9); 
                ResultSet rs = ejecucion.executeQuery();

                if (rs.next()) {
                    System.out.println("Monto total de servicios no pagados: " + rs.getDouble(1));
                }

                rs.close();
                ejecucion.close();
                conexion.close();
            } catch (Exception e) {
                System.out.println(e.getMessage());
            }
        }
    }
