package com.mongo.Normalizado;

import com.mongodb.client.*;
import static com.mongodb.client.model.Filters.*;
import java.util.Arrays;
import org.bson.Document;

/**
 *
 * @author jeron
 */
public class Pedidos {
    
     

    /**
     * @param args the command line arguments
     */
    public static void main(String[] args) {
        String uri = "mongodb://localhost:27017";
        MongoClient mongoClient = MongoClients.create(uri);
        MongoDatabase database = mongoClient.getDatabase("parcial3");
        MongoCollection<Document> collection = database.getCollection("pedidos");
        System.out.println("CONEXION EXITOSA");
        
      
        CrudPedidos crudPedidos = new CrudPedidos();
        // Crear pedido
        crudPedidos.crearPedido("pedido001", "cliente001", "02-12-2024", "enviado", 180.50);
        // Leer pedido
        crudPedidos.leerPedido("pedido001");     
        // Listar pedido
        crudPedidos.listarPedidos();
        // Actualizar pedido
        crudPedidos.actualizarPedido("pedido001", "04-14-2024");
        // Eliminar pedido
        crudPedidos.eliminarPedido("pedido001");
        
      
        //Obtener los pedidos con un total mayor a 100 dolares
        FindIterable<Document> pedidos = collection.find((gt("total", 100)));
        for (Document pedido : pedidos) {
            System.out.println(pedido.toJson());
        }

        
    }
}

        
        
        
        
        



        