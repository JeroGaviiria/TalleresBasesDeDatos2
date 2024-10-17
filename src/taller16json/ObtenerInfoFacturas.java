package taller16json;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.CallableStatement;
import java.sql.ResultSet;

public class ObtenerInfoFacturas {

    public static void main(String[] args) {
        try {
            Class.forName("org.postgresql.Driver");
            Connection conexion = DriverManager.getConnection("jdbc:postgresql://localhost:5432/postgres", "postgres", "1126");

            CallableStatement stmt = conexion.prepareCall("SELECT * FROM taller16.obtener_info_facturas()");

            ResultSet resultado = stmt.executeQuery();

            while (resultado.next()) {
                String cliente = resultado.getString("cliente");
                String identificacion = resultado.getString("identificacion");
                String codigoFactura = resultado.getString("codigo_factura");
                double total = resultado.getDouble("total");
                double descuento = resultado.getDouble("descuento");
                double totalFactura = resultado.getDouble("total_factura");

                System.out.println("Cliente: " + cliente + ", Identificacion: " + identificacion +
                                   ", Codigo Factura: " + codigoFactura + ", Total: " + total +
                                   ", Descuento: " + descuento + ", Total Factura: " + totalFactura);
            }

            resultado.close();
            stmt.close();
            conexion.close();

        } catch (Exception e) {
            System.out.println("Error: " + e.getMessage());
        }
    }
}
