add_executable(curltest main.c)

find_package(CURL)
if(CURL_FOUND)
    include_directories(${CURL_INCLUDE_DIR})
    target_link_libraries(curltest ${CURL_LIBRARY})
else()
    message(FATAL_ERROR "CURL library not found")
endif()
