package taller16json;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.CallableStatement;
import java.sql.ResultSet;

public class ObtenerProductosPorFactura {

    public static void main(String[] args) {
        try {
            Class.forName("org.postgresql.Driver");
            Connection conexion = DriverManager.getConnection("jdbc:postgresql://localhost:5432/postgres", "postgres", "1126");

            CallableStatement stmt = conexion.prepareCall("SELECT * FROM taller16.obtener_productos_por_factura(?)");

            stmt.setString(1, "F001");

            ResultSet resultado = stmt.executeQuery();

            while (resultado.next()) {
                int cantidad = resultado.getInt("cantidad");
                double valor = resultado.getDouble("valor");
                String nombreProducto = resultado.getString("nombre_producto");
                String descripcionProducto = resultado.getString("descripcion_producto");
                double precio = resultado.getDouble("precio");
                String categorias = resultado.getString("categorias");

                System.out.println("Cantidad: " + cantidad + ", Valor: " + valor + 
                                   ", Nombre Producto: " + nombreProducto + 
                                   ", Descripcion Producto: " + descripcionProducto + 
                                   ", Precio: " + precio + ", Categorias: " + categorias);
            }

            resultado.close();
            stmt.close();
            conexion.close();

        } catch (Exception e) {
            System.out.println("Error: " + e.getMessage());
        }
    }
}
