:require /opt/spark/bin/postgresql-42.2.8.jar
Class.forName("org.postgresql.Driver") != null

val url = "jdbc:postgresql://87.44.4.32:5432/proj_grp_a?user=group_a&password=groupa123"
import java.util.Properties
val connectionProperties = new Properties()
connectionProperties.setProperty("Driver", "org.postgresql.Driver")

import org.apache.spark.sql.SparkSession
val spark = SparkSession.builder().appName("Spark SQL basic example").config("spark.some.config.option", "some-value").getOrCreate()

val query1 = "(select * FROM drug_info) as q1"

val df = spark.read.jdbc(url, query1, connectionProperties)