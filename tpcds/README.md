# tpcds-kit

The official TPC-DS tools can be found at [tpc.org](http://www.tpc.org/tpc_documents_current_versions/current_specifications.asp).

This tpcds-kit is ported from [gregrahn/tpcds-kit](https://github.com/gregrahn/tpcds-kit), thanks to [gregrahn](https://github.com/gregrahn), this version is based on v2.7.0 and has been modified to:
* Allow compilation under macOS (commit [2ec45c5](https://github.com/gregrahn/tpcds-kit/commit/2ec45c5ed97cc860819ee630770231eac738097c))
* Address obvious query template bugs like
  * https://github.com/gregrahn/tpcds-kit/issues/30
  * https://github.com/gregrahn/tpcds-kit/issues/31
  * https://github.com/gregrahn/tpcds-kit/issues/33

## 1. Setup

### 1.1 install required development tools

Make sure the required development tools are installed:

- Ubuntu: `sudo apt-get install gcc make flex bison byacc git`
- CentOS/RHEL: `sudo yum install gcc make flex bison byacc git`
- MacOS: `xcode-select --install`

### 1.2 build

- Linux: `cd tools && make OS=LINUX -j8 && cd -`
- MacOS: `cd tools && make OS=MACOS -j8 && cd -`

## 2. Data generation

Data generation is done via `dsdgen`:
```sh
# "-sc" is used to specify the volume of data to generate in GB.
cd tools && ./dsdgen -sc 1 -f && cd -
```

## 3. DataBase and Table schema generation
```sh
mysql -h 127.0.0.1 -P 4000 -u root -D test -e "drop database if exists tpcds;"
mysql -h 127.0.0.1 -P 4000 -u root -D test -e "create database tpcds;"
mysql -h 127.0.0.1 -P 4000 -u root -D tpcds < tools/tpcds.sql
```

## 4. Load Data
```sh
rm -rf load_data.log
touch load_data.log
for file_name in `ls tools/*.dat`; do
    table_file=$(echo "${file_name##*/}")
    table_name=$(echo "${table_file%.*}" | tr '[:lower:]' '[:upper:]')
    load_data_sql="LOAD DATA LOCAL INFILE '$file_name' INTO TABLE $table_name FIELDS TERMINATED BY '|' LINES TERMINATED BY '\n';"
    mysql -h 127.0.0.1 -P 4000 -u root --local-infile=1 -D tpcds -e "$load_data_sql" >> load_data.log 2>&1 &
done
```

## 5. Query generation

Query generation is done via `dsqgen` with query templetes, here we use a pre-written shell script file [genquery.sh](./genquery.sh), after running this script, queries are located in directory "queries":
```sh
./genquery.sh
```

All supported TPC-DS queries for TiDB are generated in `tools/queries`

## 6. For lazy/advanced users

[load_data.sh](./load_data.sh) can be used to complete step 1~4, look into that file for more details.

## 7. CTE queries
| **Affected** ||||||
| --- | --- | --- | --- | --- | --- |
| [query1.tpl](/tpcds/query_templates/query1.tpl) | [query14.tpl](/tpcds/query_templates/query14.tpl) | [query33.tpl](/tpcds/query_templates/query33.tpl) | [query56.tpl](/tpcds/query_templates/query56.tpl) | [query64.tpl](/tpcds/query_templates/query64.tpl) | [query80.tpl](/tpcds/query_templates/query80.tpl) |
| [query2.tpl](/tpcds/query_templates/query2.tpl) | [query23.tpl](/tpcds/query_templates/query23.tpl) | [query39.tpl](/tpcds/query_templates/query39.tpl) | [query57.tpl](/tpcds/query_templates/query57.tpl) | [query74.tpl](/tpcds/query_templates/query74.tpl) | [query81.tpl](/tpcds/query_templates/query81.tpl) |
| [query4.tpl](/tpcds/query_templates/query4.tpl) | [query24.tpl](/tpcds/query_templates/query24.tpl) | [query47.tpl](/tpcds/query_templates/query47.tpl) | [query58.tpl](/tpcds/query_templates/query58.tpl) | [query75.tpl](/tpcds/query_templates/query75.tpl) | [query83.tpl](/tpcds/query_templates/query83.tpl) |
| [query5.tpl](/tpcds/query_templates/query5.tpl) | [query30.tpl](/tpcds/query_templates/query30.tpl) | [query51.tpl](/tpcds/query_templates/query51.tpl) | [query59.tpl](/tpcds/query_templates/query59.tpl) | [query77.tpl](/tpcds/query_templates/query77.tpl) | [query95.tpl](/tpcds/query_templates/query95.tpl) |
| [query11.tpl](/tpcds/query_templates/query11.tpl) | [query31.tpl](/tpcds/query_templates/query31.tpl) | [query54.tpl](/tpcds/query_templates/query54.tpl) | [query60.tpl](/tpcds/query_templates/query60.tpl) | [query78.tpl](/tpcds/query_templates/query78.tpl) | [query97.tpl](/tpcds/query_templates/query97.tpl) |
