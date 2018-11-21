package migracao;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class Connect {   
    
    private static final String URL = "localhost";
    private static final String DB = "CentroHipico";
    private static final String USERNAME = "root"; //TODO: alterar
    private static final String PASSWORD = "1234"; //TODO: alterar
    
    public static Connection connect() throws SQLException, ClassNotFoundException {
        Class.forName("com.mysql.jdbc.Driver");
        
        return DriverManager.getConnection("jdbc:mysql://"+URL+"/"+DB+"?user="+USERNAME+"&password="+PASSWORD+"&autoReconnect=true&useSSL=false");    
    }

    public static void close(Connection c) {
        try {
            if(c!=null && !c.isClosed()) {
                c.close();
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
