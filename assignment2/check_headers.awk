BEGIN {cust = 0; add = 0; cate = 0; item = 0}

/^customer/ {cust = 1}
/^address/ {add = 1}
/^categories/ {cate = 1}
/^items/ {item = 1}

END {
    if (!cust) {
        print "No 'customer' header"
        exit 1
    }
    if (!add) {
        print "No 'address' header"
        exit 1
    }
    if (!cate) {
        print "No 'categories' header"
        exit 1
    }
    if (!item) {
        print "No 'items' header"
        exit 1
    }
}