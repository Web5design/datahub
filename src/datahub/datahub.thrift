/**
 * datahub.thrift
 * IDL for DataHub Services
 *
 * @author: Anant Bhardwaj
 * @date: 10/09/2013
 *
 */

namespace py datahub

// DataHub constants
const double VERSION = 1.0


// DataHub Generic Exception
exception DHException {
  1: optional i32 errorCode,
  2: optional string message,
  3: optional string details
}


// DataHub Connection Abstraction
struct DHDatabase {
  1: optional string url
  2: optional string name 
}

struct DHConnectionParams {
  1: optional string user,
  2: optional string password,
  3: optional DHDatabase database
}

struct DHConnection {
  1: optional string id,
  2: optional string user,
  3: optional DHDatabase database
}

 
// DataHub Schema
enum DHType {
  Boolen,
  Integer,
  Double,
  String,
  Binary,
  Date,
  DateTime,
  TimeStamp
}

struct DHIndex {
  1: optional bool primary,
  2: optional bool unique,
  3: optional bool btree_index,
  4: optional bool fulltext_index
}

union DHOrder {
  1: optional bool ascending,
  2: optional bool descending
}

union DHDefault {
  1: optional binary value,
  2: optional bool null ,
  3: optional bool current_timestamp
}

struct DHColumnSpec {
  1: optional i32 id,
  2: optional i32 version_number,
  3: optional string column_name,
  4: optional DHType column_type,
  5: optional i32 length,
  6: optional DHDefault default_val,
  7: optional list <DHIndex> index,
  8: optional bool null_allowed,
  9: optional bool auto_increment,
  10: optional DHOrder order
}

struct DHTableSchema {
  1: optional i32 id,
  2: optional i32 version_number,
  3: optional list <DHColumnSpec> column_specs,
}


// DataHub Table Abstraction
struct DHCell {
  1: optional binary value
}

struct DHRow {
  1: optional i32 id,
  2: optional i32 version_number,
  3: optional list <DHCell> cells,
}

struct DHTableData {
  1: optional i32 id,
  2: optional i32 version_number,
  3: optional list <DHRow> rows
}

struct DHTable {
  1: optional i32 id,
  2: optional i32 version_number 
  3: optional DHTableSchema table_schema,
  4: optional DHTableData table_data, 
}


// DataHub Query Result
struct DHQueryResult {
  1: required bool status,
  2: optional i32 error_code,
  3: optional i32 row_count,
  4: optional DHTable table,
}


// DataHub service APIs
service DataHub {
  double get_version()
  DHConnection connect(1:DHConnectionParams con_params)
      throws (1: DHException ex)
  DHConnection open_database(1:DHConnection con, 2:DHDatabase database)
      throws (1: DHException ex)
  DHQueryResult list_databases(1:DHConnection con)
      throws (1: DHException ex)
  DHQueryResult list_tables(1:DHConnection con) throws (1: DHException ex)
  DHQueryResult execute_sql(1:DHConnection con, 2: string query,
      3: list <string> query_params) throws (1: DHException ex)
}
