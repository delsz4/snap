#!/bin/bash
  del="#######################################"         # delimiter
  set -e                                                # exit on error
  n=0                                                   # count amount of tests executed (exception for subsecond calls)
  loops=1;
  stimfile=$(basename "$0"); logfile="${stimfile%.*}.log"; ts0=$(date +%s); echo "executing $stimfile, logging $logfile maxloop=$loops";
  for((i=1;i<=loops;i++)) do l="loop=$i of $loops"; ts1=$(date +%s);                                                                                 #  sec
#   t="$DONUT_ROOT/software/tools/dnut_peek -h"                                                 ;echo -e "$del\n$t $l";                   $t;echo "RC=$?" #  1
    t="$DONUT_ROOT/software/tools/dnut_peek 0x0         "                                       ;echo -e "$del\n$t $l";                   $t;echo "RC=$?" #  1
#   t="$DONUT_ROOT/software/tools/dnut_peek 0x10000 -w32"                                       ;echo -e "$del\n$t $l";                   $t;echo "RC=$?" #  1
    t="$DONUT_ROOT/software/tools/dnut_peek 0x0         ";     r=$($t|grep ']'|awk '{print $2}');echo -e "$t result=$r # release maj.int.min.dist.4Bsha"
    t="$DONUT_ROOT/software/tools/dnut_peek 0x8         ";     r=$($t|grep ']'|awk '{print $2}');echo -e "$t result=$r # build date 0000YYYY.MM.DD.hh.mm"
    t="$DONUT_ROOT/software/tools/dnut_peek 0x10        ";     r=$($t|grep ']'|awk '{print $2}');echo -e "$t result=$r # cmdreg 0x10=exploration done"
                                                               done=${r:14:1};echo "done=$done";
    if [[ $done == "0" ]];then echo "need to run maint pgm"
#     t="$DONUT_ROOT/software/tools/snap_maint -h -V"                                           ;echo -e "$del\n$t $l";                   $t;echo "RC=$?" #
#     t="$DONUT_ROOT/software/tools/snap_maint"                                                 ;echo -e "$del\n$t $l";date;((n+=1));time $t;echo "RC=$?" #
      t="$DONUT_ROOT/software/tools/snap_maint -m1 -c1"                                         ;echo -e "$del\n$t $l";date;((n+=1));time $t;echo "RC=$?" #
#     t="$DONUT_ROOT/software/tools/snap_maint -m1 -c1 -vvv"                                    ;echo -e "$del\n$t $l";date;((n+=1));time $t;echo "RC=$?" #
#     t="$DONUT_ROOT/software/tools/snap_maint -m2 -c1 -vvv"                                    ;echo -e "$del\n$t $l";date;((n+=1));time $t;echo "RC=$?" #
    fi
    t="$DONUT_ROOT/software/tools/dnut_peek 0x10        ";     r=$($t|grep ']'|awk '{print $2}');echo -e "$t result=$r # cmdreg 0x10=exploration done"
    t="$DONUT_ROOT/software/tools/dnut_peek 0x18        ";     r=$($t|grep ']'|awk '{print $2}');echo -e "$t result=$r # statusreg 0x100=exploration done 1action, 0x111=2action"
                                                               done=${r:13:1};numact=${r:14:1};(( numact += 1 ));echo "done=$done num_actions=$numact"
    t="$DONUT_ROOT/software/tools/dnut_peek 0x80        ";     r=$($t|grep ']'|awk '{print $2}');echo -e "$t result=$r # freerunning timer"
    t="$DONUT_ROOT/software/tools/dnut_peek 0x88        ";     r=$($t|grep ']'|awk '{print $2}');echo -e "$t result=$r # timeout reg"
    t="$DONUT_ROOT/software/tools/dnut_peek 0x90        ";     r=$($t|grep ']'|awk '{print $2}');echo -e "$t result=$r # action active counter"
    t="$DONUT_ROOT/software/tools/dnut_peek 0x98        ";     r=$($t|grep ']'|awk '{print $2}');echo -e "$t result=$r # job execution counter"
    t="$DONUT_ROOT/software/tools/dnut_peek 0xA0        ";     r=$($t|grep ']'|awk '{print $2}');echo -e "$t result=$r # job IDreg 8=master"
    if (( numact > 0 ));then
      t="$DONUT_ROOT/software/tools/dnut_peek 0x100       ";   r=$($t|grep ']'|awk '{print $2}');echo -e "$t result=$r # action0 type 0.0.0.shrt.4B_long"
                                                               t0s=${r:7:1};t0l=${r:8:8};if [[ $t0l == "00000001" ]];then a0="memcopy";else a0="unknown";fi; echo "action0 type0s=$t0s type0l=$t0l $a0"
      t="$DONUT_ROOT/software/tools/dnut_peek 0x10000 -w32";   r=$($t|grep ']'|awk '{print $2}');echo -e "$t result=$r # release"
      t="$DONUT_ROOT/software/tools/dnut_peek 0x10008 -w32";   r=$($t|grep ']'|awk '{print $2}');echo -e "$t result=$r # build date"
      t="$DONUT_ROOT/software/tools/dnut_peek 0x10010 -w32";   r=$($t|grep ']'|awk '{print $2}');echo -e "$t result=$r # cmdreg"
      t="$DONUT_ROOT/software/tools/dnut_peek 0x10018 -w32";   r=$($t|grep ']'|awk '{print $2}');echo -e "$t result=$r # statusreg"
    fi
    if (( numact > 1 ));then
      t="$DONUT_ROOT/software/tools/dnut_peek 0x108       ";   r=$($t|grep ']'|awk '{print $2}');echo -e "$t result=$r # action1 type 0.0.0.shrt.4B_long"
                                                               t1s=${r:7:1};t1l=${r:8:8};if [[ $t1l == "00000001" ]];then a1="memcopy";else a1="unknown";fi; echo "action1 type0s=$t0s type0l=$t0l $a1"
      t="$DONUT_ROOT/software/tools/dnut_peek 0x11000 -w32";   r=$($t|grep ']'|awk '{print $2}');echo -e "$t result=$r # release"
      t="$DONUT_ROOT/software/tools/dnut_peek 0x11008 -w32";   r=$($t|grep ']'|awk '{print $2}');echo -e "$t result=$r # build date"
      t="$DONUT_ROOT/software/tools/dnut_peek 0x11010 -w32";   r=$($t|grep ']'|awk '{print $2}');echo -e "$t result=$r # cmdreg"
      t="$DONUT_ROOT/software/tools/dnut_peek 0x11018 -w32";   r=$($t|grep ']'|awk '{print $2}');echo -e "$t result=$r # statusreg"
    fi

    action=$(echo $ACTION_ROOT|sed -e "s/action_examples\// /g"|awk '{print $2}')               ;echo -e "$del\nENV_action=$action"
    if [[ $t0l == "00000001" ]];then echo "testing memcopy"
#   if [[ $action == *"memcopy"* ]];then echo "testing memcopy"
#     t="$DONUT_ROOT/software/tools/stage1                        -v  "                         ;echo -e "$del\n$t $l";date;((n+=1));time $t;echo "RC=$?" #  4..timeout endless
#     t="$DONUT_ROOT/software/tools/stage1                 -t10   -v  "                         ;echo -e "$del\n$t $l";date;((n+=1));time $t;echo "RC=$?" #e invalid option -t
#     t="$DONUT_ROOT/software/tools/stage2 -h"                                                  ;echo -e "$del\n$t $l";                   $t;echo "RC=$?" #
#     t="$DONUT_ROOT/software/tools/stage2                 -t100      "                         ;echo -e "$del\n$t $l";date;((n+=1));time $t;echo "RC=$?" #  4..105
#     t="$DONUT_ROOT/software/tools/stage2     -s2 -e4 -i1 -t40       "                         ;echo -e "$del\n$t $l";date;((n+=1));time $t;echo "RC=$?" #  2..33
#     t="$DONUT_ROOT/software/tools/stage2 -a1             -t200"                               ;echo -e "$del\n$t $l";date;((n+=1));time $t;echo "RC=$?" #t 4..112..33min
      t="$DONUT_ROOT/software/tools/stage2 -a1 -s2 -e4 -i1 -t10"                                ;echo -e "$del\n$t $l";date;((n+=1));time $t;echo "RC=$?" #  2..34
#     t="$DONUT_ROOT/software/tools/stage2 -a1 -s2 -e8 -i1 -t100"                               ;echo -e "$del\n$t $l";date;((n+=1));time $t;echo "RC=$?" #  5..76..12min
#     t="$DONUT_ROOT/software/tools/stage2 -a2                    -vvv"                         ;echo -e "$del\n$t $l";date;((n+=1));time $t;echo "RC=$?" #e memcmp failed
#     t="$DONUT_ROOT/software/tools/stage2 -a2 -z0         -t50   -v  "                         ;echo -e "$del\n$t $l";date;((n+=1));time $t;echo "RC=$?" #e memcmp failed
#     t="$DONUT_ROOT/software/tools/stage2 -a2 -z1         -t100      "                         ;echo -e "$del\n$t $l";date;((n+=1));time $t;echo "RC=$?" #  4
#     t="$DONUT_ROOT/software/tools/stage2 -a2 -z2         -t500  -v  "                         ;echo -e "$del\n$t $l";date;((n+=1));time $t;echo "RC=$?" #t timeout
#     t="$DONUT_ROOT/software/tools/stage2 -a3             -t10       "                         ;echo -e "$del\n$t $l";date;((n+=1));time $t;echo "RC=$?" #  1
#     t="$DONUT_ROOT/software/tools/stage2 -a4             -t10       "                         ;echo -e "$del\n$t $l";date;((n+=1));time $t;echo "RC=$?" #  1..2
#     t="$DONUT_ROOT/software/tools/stage2 -a5             -t10       "                         ;echo -e "$del\n$t $l";date;((n+=1));time $t;echo "RC=$?" #  1..3
#     t="$DONUT_ROOT/software/tools/stage2 -a6                    -vvv"                         ;echo -e "$del\n$t $l";date;((n+=1));time $t;echo "RC=$?" #e memcmp error
#     t="$DONUT_ROOT/software/tools/stage2 -a6 -z1         -t100      "                         ;echo -e "$del\n$t $l";date;((n+=1));time $t;echo "RC=$?" #  6..10
      for num4k in 0 1; do
      for num64 in 1 2; do
      for align in 4096 1024 256 64; do
        t="$DONUT_ROOT/software/tools/stage2 -a2 -A${align} -S${num4k} -B${num64} -t200"        ;echo -e "$del\n$t $l";date;((n+=1));time $t;echo "RC=$?" #
      done
      done
      done

      for num64 in 1 5 63 64;do         # 1..64
      for align in 4096 1024 256 64; do # must be mult of 64
      for num4k in 0 1 3 7; do          # 1=6sec, 7=20sec
        t="$DONUT_ROOT/software/tools/stage2 -a6 -A${align} -S${num4k} -B${num64} -t200"        ;echo -e "$del\n$t $l";date;((n+=1));time $t;echo "RC=$?" #
      done
      done
      done

#     #### check DDR3 memory in KU3
#     t="$DONUT_ROOT/software/tools/stage2_ddr -h"                                              ;echo -e "$del\n$t $l";                   $t;echo "RC=$?" #
#     for strt in 0x1000 0x2000;do      # start adr
#     for iter in 1 2 3;do              # number of blocks
#     for bsize in 64 0x1000; do        # block size
#       let end=${strt}+${iter}*${bsize}
#       t="$DONUT_ROOT/software/tools/stage2_ddr -s${strt} -e${end} -b${bsize} -i${iter} -t200" ;echo -e "$del\n$t $l";date;((n+=1));time $t;echo "RC=$?" #
#     done
#     done
#     done
#
#     #### use memset in host or in fpga memory
#     t="$DONUT_ROOT/software/tools/stage2_set -h"                                              ;echo -e "$del\n$t $l";                   $t;echo "RC=$?" #
#     for beg in 0 1 11 63 64;do         # start adr
#     for size in 1 7 4097; do           # block size to copy
#       t="$DONUT_ROOT/software/tools/stage2_set -H -b${beg} -s${size} -p${size} -t200"         ;echo -e "$del\n$t $l";date;((n+=1));time $t;echo "RC=$?" #
#       t="$DONUT_ROOT/software/tools/stage2_set -F -b${beg} -s${size} -p${size} -t200"         ;echo -e "$del\n$t $l";date;((n+=1));time $t;echo "RC=$?" #
#     done
#     done
    fi # memcopy

    if [[ $action == *"hls_mem"* || $action == *"hls_search"* ]];then echo "testing demo_memcopy"
      t="$DONUT_ROOT/software/examples/demo_memcopy -h"                                         ;echo -e "$del\n$t $l";                   $t;echo "RC=$?" #  5..7
#     t="$DONUT_ROOT/software/examples/demo_memcopy -C0 -i ../../1KB.txt -o 1KB.out -t10"       ;echo -e "$del\n$t $l";date;((n+=1));time $t;echo "RC=$?" #  5..7
      #### select 1 selection loop
      # for size in 2 83; do                      # still error with 83B ?
        for size in 2 8 16 64 128 256 512 1024; do # 64B aligned       01/20/2017: error 128B
      # for size in 2 31 32 33 64 65 80 81 83 255 256 257 1024 1025 4096 4097; do
        #### select 1 checking method
        # t="$DONUT_ROOT/software/examples/demo_memcopy -i ${size}.in -o ${size}.out -v -t20"   ;echo -e "$del\n$t $l"; # memcopy without checking behind buffer
          t="$DONUT_ROOT/software/examples/demo_memcopy -i ${size}.in -o ${size}.out -v -X -t20";echo -e "$del\n$t $l"; # memcopy with checking behind buffer
        #### select 1 type of data generation
        # head -c $size </dev/zero|tr '\0' 'x' >${size}.in;head ${size}.in;echo                         # same char mult times
        # cmd='print("A" * '${size}', end="")'; python3 -c "$cmd" >${size}.in;head ${size}.in;echo      # deterministic char string generated with python
        # cat /dev/urandom|tr -dc 'a-zA-Z0-9'|fold -w ${size}|head -n 1 >${size}.in;head ${size}.in     # random data alphanumeric, includes EOF
          dd if=/dev/urandom bs=${size} count=1 >${size}.in                                             # random data any char, no echo due to unprintable char
        ((n+=1));time $t;rc=$?;if diff ${size}.in ${size}.out>/dev/null;then echo "RC=$rc file_diff ok";rm ${size}.*;else echo -e "$t RC=$rc file_diff is wrong\n$del";exit 1;fi
      done
    fi # hls_memcopy

    if [[ $action == *"hls_search"* ]];then echo "testing demo_search"
      t="$DONUT_ROOT/software/examples/demo_search -h"                                          ;echo -e "$del\n$t $l";              $t;echo "RC=$?" #
#     t="$DONUT_ROOT/software/examples/demo_search -p'A' -C0 -i ../../1KB.txt   -t100      "    ;echo -e "$del\n$t $l";((n+=1));time $t;echo "RC=$?" # 31..34
#     t="$DONUT_ROOT/software/examples/demo_search -pX       -i ../../1KB.txt   -t100      "    ;echo -e "$del\n$t $l";((n+=1));time $t;echo "RC=$?" # 32..35
#     t="$DONUT_ROOT/software/examples/demo_search -p0123    -i ../../1KB.txt   -t500      "    ;echo -e "$del\n$t $l";((n+=1));time $t;echo "RC=$?" # 33
#     t="$DONUT_ROOT/software/examples/demo_search -ph       -i ../../1KB.txt   -t100      "    ;echo -e "$del\n$t $l";((n+=1));time $t;echo "RC=$?" # 31..32
#     t="$DONUT_ROOT/software/examples/demo_search -ph       -i ../../1KB.txt   -t100  -vvv"    ;echo -e "$del\n$t $l";((n+=1));time $t;echo "RC=$?" # 33
#     t="$DONUT_ROOT/software/examples/demo_search -p.       -i ../../fox1.txt  -t30   -v  "    ;echo -e "$del\n$t $l";((n+=1));time $t;echo "RC=$?" #
#     t="$DONUT_ROOT/software/examples/demo_search -p.       -i ../../fox10.txt -t80   -v  "    ;echo -e "$del\n$t $l";((n+=1));time $t;echo "RC=$?" #
#     t="$DONUT_ROOT/software/examples/demo_search -px       -i ../../fox1.txt  -t30   -v  "    ;echo -e "$del\n$t $l";((n+=1));time $t;echo "RC=$?" #
      #### select one loop type
      # for size in 20 83; do
      # for size in {1..5}; do
        for size in 2 20 30 31 32 33 80 81 255 256 257 1024 1025 4096 4097; do
        echo -e " $del\n"; to=$((size/3+100))                                                           # rough timeout dependent on filesize
        #### select 1 search char
          char=$(cat /dev/urandom|tr -dc 'a-zA-Z0-9'|fold -w 1|head -n 1)                               # one random ASCII  char to search for
        # char='A'                                                                                      # one deterministic char to search for
        #### select 1 type of data generation
        # head -c $size </dev/zero|tr '\0' 'x' >${size}.in;head ${size}.in;echo                         # same char mult times
          cat /dev/urandom|tr -dc 'a-zA-Z0-9'|fold -w ${size}|head -n 1 >${size}.in;head ${size}.in     # random data alphanumeric, includes EOF
        # dd if=/dev/urandom bs=${size} count=1 >${size}.in;                                            # random data any char, no echo due to unprintable char
        # cmd='print("A" * '${size}', end="")'; python3 -c "$cmd" >${size}.in;head ${size}.in;echo      # data generated with python
        count=$(fgrep -o $char ${size}.in|wc -l);                                                       # expected occurence of char in file
        t="$DONUT_ROOT/software/examples/demo_search -p${char} -i${size}.in -E${count} -t$to -v";echo -e "$t $l";((n+=1));time $t;echo "RC=$?"
      done
    fi # hls_search

    if [[ $action == *"hls_hash"* ]];then echo "testing demo_hashjoin"
      t="$DONUT_ROOT/software/examples/demo_hashjoin -h"                                        ;echo -e "$del\n$t $l";              $t;echo "RC=$?" #
      t="$DONUT_ROOT/software/examples/demo_hashjoin       -t300 -vvv"                          ;echo -e "$del\n$t $l";((n+=1));time $t;echo "RC=$?" # 1m26s
      t="$DONUT_ROOT/software/examples/demo_hashjoin -T1   -t300 -vvv"                          ;echo -e "$del\n$t $l";((n+=1));time $t;echo "RC=$?" #   49s
      t="$DONUT_ROOT/software/examples/demo_hashjoin -T15  -t300 -vvv"                          ;echo -e "$del\n$t $l";((n+=1));time $t;echo "RC=$?" # 1m17s
#     t="$DONUT_ROOT/software/examples/demo_hashjoin -T257 -t600 -vvv"                          ;echo -e "$del\n$t $l";((n+=1));time $t;echo "RC=$?" # 8m51s
      t="$DONUT_ROOT/software/examples/demo_hashjoin -Q1   -t300 -vvv"                          ;echo -e "$del\n$t $l";((n+=1));time $t;echo "RC=$?" #   25s
      t="$DONUT_ROOT/software/examples/demo_hashjoin -Q5   -t300 -vvv"                          ;echo -e "$del\n$t $l";((n+=1));time $t;echo "RC=$?" #   33s
#     t="$DONUT_ROOT/software/examples/demo_hashjoin -Q8   -t300 -vvv"                          ;echo -e "$del\n$t $l";((n+=1));time $t;echo "RC=$?" #   40s
#     t="$DONUT_ROOT/software/examples/demo_hashjoin -Q16  -t300 -vvv"                          ;echo -e "$del\n$t $l";((n+=1));time $t;echo "RC=$?" # 1m02s
      t="$DONUT_ROOT/software/examples/demo_hashjoin -Q32  -t300 -vvv"                          ;echo -e "$del\n$t $l";((n+=1));time $t;echo "RC=$?" # 1m45s
#     t="$DONUT_ROOT/software/examples/demo_hashjoin -Q257 -t300 -vvv"                          ;echo -e "$del\n$t $l";((n+=1));time $t;echo "RC=$?" #e too large
    fi # hls_hashjoin

    ts2=$(date +%s); looptime=`expr $ts2 - $ts1`; echo "looptime=$looptime"
  done; l=""; ts3=$(date +%s); totaltime=`expr $ts3 - $ts0`; echo "loops=$loops tests=$n total_time=$totaltime"
