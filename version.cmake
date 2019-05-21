set(VERSION 0.0.1)
string(TIMESTAMP BUILD_DATE "%Y-%m-%d" UTC)
execute_process(
  COMMAND git rev-parse --short HEAD
  RESULT_VARIABLE SHORT_HASH_RESULT
  OUTPUT_VARIABLE SHORT_HASH
)

add_compile_definitions(AppVersion="${VERSION}"
    AppName="%{ProjectName}"
    CompanyName="Milo Solutions"
    CompanyDomain="milosolutions.com"
    BuildDate="${BUILD_DATE}"
    GitCommit="${SHORT_HASH}"
    )
