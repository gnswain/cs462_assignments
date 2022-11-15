BEGIN {cust = 0; add = 0; cate = 0; item = 0}

/^customer/ {cust = 1}
/^address/ {add = 1}
/^categories/ {cate = 1}
/^items/ {item = 1}

END {
    # uncomment this to have a more specific error message
    # valid = 0
    # if (cust == 0) {
    #     print "ERROR: No 'customer' header"
    #     valid = 1
    # }
    # if (add == 0) {
    #     print "ERROR: No 'address' header"
    #     valid = 1
    # }
    # if (cate == 0) {
    #     print "ERROR: No 'categories' header"
    #     valid = 1
    # }
    # if (item == 0) {
    #     print "ERROR: No 'items' header"
    #     valid = 1
    # }
    # if (valid == 1) {
    #     print "Last header line:", $0
    #     exit 1
    # }

    if (cust != 1 || add != 1 || cate != 1 || item != 1) {
        print "ERROR: Missing header line"
        print "Last header line:", $0
        exit 1
    }
}