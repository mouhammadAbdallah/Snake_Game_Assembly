
*-----------------------------------------------------------
* Title      :Snake Game
* Written by :Mohamad Abdallah
* Date       :15-12-2019
* Description:manual and smart snake
*-----------------------------------------------------------

* Delay for hundredths of a second in param 1
DELAY    MACRO
    move.b  #23,d0          trap task 23
    move.l  #\1,d1          delay amount
    trap    #15
    ENDM
    
    
    ORG    $1000
START:                  ; first instruction of program

* Put program code here

    MOVE.B #33,D0
    MOVE.L #1280*$10000+800,D1  Set screen to 1280 x 800
    TRAP   #15
        
    
    ;snake of 1
    move.w #1,N
    ;snake beginning position
    move.w #(20*snakeSquare),X
    move.w #(10*snakeSquare),Y
    ;feed beginning position
    move.w #(10*snakeSquare),XF
    move.w #(10*snakeSquare),YF
    ;snake beginning direction 
    move.w #(-snakeSquare),dXN
    move.w #0,dYN
    ;no smart snake
    move.b #0,smart
    ;no grid
    move.b #0,grid
    
loop 
    JSR refresh 
    move.b  #7,d0                   ; check for pending key press
    trap    #15
    tst.b d1
    beq endif

      move.b    #5,d0               ; read key
      trap      #15
      if.b d1 <eq> #'6' then.s      ; if '6' pressed
        move.b #0,smart
        move.w dXN,d5
        blt loop
        move.w #snakeSquare,dXN
        move.w #0,dYN

      endi
       if.b d1 <eq> #'g' then.s      ; if 'g pressed
        move.b #1,grid
       endi
       if.b d1 <eq> #'h' then.s      ; if 'h pressed
        move.b #0,grid
       endi
      if.b d1 <eq> #'8' then.s      ; if '8' pressed
        move.b #0,smart
        move.w dYN,d5
        BHI loop
        move.w #0,dXN
        move.w #(-snakeSquare),dYN

       endi
      if.b d1 <eq> #'4' then.s      ; if '4' pressed
        move.b #0,smart
        move.w dXN,d5
        Bgt loop
        move.w #(-snakeSquare),dXN
        move.w #0,dYN
      endi
      if.b d1 <eq> #'5' then.s      ; if '5' pressed
        move.b #0,smart
        move.w dYN,d5
        blt loop
        move.w #0,dXN
        move.w #snakeSquare,dYN

      endi
      cmp.b #'s',d1 ; if 's' pressed
      bne endif1
      ;if.b d1 <eq> #'s' then.s      ; if 's' pressed
        move.b #1,smart ;smart mood
        
sss     move.w dXN,d5
        beq smy
        ;dx!=0
        move.b #1,smartX
        move.w #0,dXN
        move.w YF,d5
        cmp.w Y,d5
        ble else0
        move.w #snakeSquare,dYN
        bra fin0
else0   move.w #(-snakeSquare),dYN
fin0    move.w X,d0
        move.w N,d3
        lea X,A0
chk0    subq #1,d3
        beq nopb0
        addq #8,A0
        cmp.w (A0),d0
        bne chk0
        move.w 2(A0),d6
        sub.w Y,d6
        move.w 2(A0),d5
        sub.w YF,d5
        muls.w d5,d6
        bge nopb0
        neg.w dYN


smy
nopb0        
endif1

endif 

  
    bra     loop 


refresh
        JSR clrScreen
        
        tst.b smart
        beq nosmart
        tst.b smartX
        beq maybey
        move.w YF,d3
        cmp.w Y,d3
        bne nosmart
        move.b #0,smartX
        move.w #0,dYN
        move.w XF,d5
        cmp.w X,d5
        ble else1
        move.w #snakeSquare,dXN
        bra fin1
else1   move.w #(-snakeSquare),dXN
fin1    move.w Y,d0
        move.w N,d3
        lea Y,A0
chk1    subq #1,d3
        beq nopb1
        addq #8,A0
        cmp.w (A0),d0
        bne chk1
        move.w -2(A0),d6
        sub.w X,d6
        move.w -2(A0),d5
        sub.w XF,d5
        muls.w d5,d6
        bge nopb1
        neg.w dXN
        
nopb1       
maybey        
        
; calculate the future deltax and deltay for all the part of the snake
nosmart move.w N,d0
        cmp.w #1,d0
        beq nothingToDo
        
        lea X,A0
        move.w d0,d1
        mulu #8,d1
        adda.w d1,A0
        suba.w #12,A0
otherPart        
        move.l (A0),d6
        move.l d6,$0008(A0)
        subq #8,A0
        subq #1,d0
        cmp.w #1,d0
        bne otherPart
        
        
        
nothingToDo
        move.l dXN,deltaX
        ;the next X
        lea X,A0
        lea Y,A1
        lea deltaX,A2
        lea deltaY,A3
        move.w N,d3
        
otherPoint
        move.w (A0),d0
        move.w (A1),d1
        add.w (A2),d0
        cmp.w #1280,d0
        blt xch
        move.w 0,d0
        bra yok ;xok
xch     cmp.w #0,d0
        bge xok
        move.w #(1280-snakeSquare),d0 
        
        ;the next Y
xok     move.w (A1),d1
        add.w (A3),d1
        cmp.w #800,d1
        blt ych
        move.w 0,d1
        bra yok 
ych     cmp.w #0,d1
        bge yok
        move.w #(800-snakeSquare),d1
        
yok     move.w d0,(A0)
        move.w d1,(A1)
        
        addq #8,A0
        addq #8,A1
        addq #8,A2
        addq #8,A3
        subq #1,d3
        bne otherPoint
        
    ;draw the snake
    
         move.l  #NAVY,d1   
         move.b  #80,d0  set pen color
         trap #15     

         move.l  #RED,d1   
         move.b  #81,d0  set fill color
         trap #15 
    
        lea X,A0
        lea Y,A1
        move.w N,d6

drawOtherPoint             
        move.w  (A0),d1      LX        draw snake
        move.w  (A1),d2      UY 
        move.w  d1,d3   RX
        addi.w  #snakeSquare,d3
        move.w  d2,d4     LY 
        addi.w  #snakeSquare,d4
        move.b  #87,d0     draw filled rectangle
        trap #15
        
        addq #8,A0
        addq #8,A1
        subq #1,d6
        bne drawOtherPoint
        
        ; draw the feed
         move.l  #AQUA,d1   
         move.b  #80,d0  set pen color
         trap #15     

         move.l  #BLUE,d1   
         move.b  #81,d0  set fill color
         trap #15     
        
        
        
        move.w  XF,d1      LX       draw feed
        move.w  YF,d2      UY 
        move.w  d1,d3   RX
        addi.w  #snakeSquare,d3
        move.w  d2,d4     LY 
        addi.w  #snakeSquare,d4
        move.b  #87,d0     draw filled rectangle
        trap #15
        
        ;detect if the snake in accident
        move.w #X,A1
        move.w #Y,A2
        move.w X,d1
        move.w Y,d2
        move.w N,D0
        cmp.w #1,D0
        beq noPb
notpb   adda #8,A1
        adda #8,A2
        subq #1,d0
        cmp.w #1,d0
        beq noPb
        move.w (A1),d3
        cmp.w d1,d3
        bne notpb
        move.w (A2),d4
        cmp.w d2,d4
        bne notpb
        ;sound
playr   lea   missSound,a1
        move    #70,d0
        trap    #15    
        tst.w   d0              d0 = 0 if player is busy
        beq     playr           loop until sound plays
        DELAY 100
playr1  lea   zeroSound,a1
        move    #70,d0
        trap    #15    
        tst.w   d0              d0 = 0 if player is busy
        beq     playr1          loop until sound plays
        bra START
        
        ;detect if the snake finds the feed 
noPb    move.w X,d0
        move.w XF,d1
        cmp.w d0,d1
        bne continue
        move.w Y,d0
        move.w YF,d1
        cmp.w d0,d1
        bne continue
        
        ;sound when a feed is eaten
playr0   lea   missSound,a1
        move    #70,d0
        trap    #15    
        tst.w   d0              d0 = 0 if player is busy
        beq     playr0           loop until sound plays
        

   
       ;place the new feed when the snake finds the feed 
        ;determine the X feed 
anotherone
        move.b  #8,d0       Read timer, get 100ths of a second since midnight in D1.L
        trap    #15
        and.l   #$04FFFFFF,d1 
        divu #1280,d1  
        swap d1
        clr.l d2
        move.w d1,d2
        divu #snakeSquare,d2
        clr.l d3
        move.w d2,d3
        mulu #snakeSquare,d3
        move.w d3,XF
        
        ;determine the Y feed
        
        move.b  #8,d0       Read timer, get 100ths of a second since midnight in D1.L
        trap    #15
        and.l   #$02FFFFFF,d1
        divu #800,d1  
        swap d1
        clr.l d2
        move.w d1,d2
        divu #snakeSquare,d2
        clr.l d3
        move.w d2,d3
        mulu #snakeSquare,d3
        move.w d3,YF
        
        cmp.w YFE,d3
        beq anotherone
        move.w XF,d4
        cmp.w XFE,d4
        beq anotherone
        move.w d4,XFE
        move.w d3,YFE
        
        ;create new square 
        move.w N,d0
        lea X,A0
        move.w d0,d1
        mulu.w #8,d1
        adda.w d1,A0
        subq #8,A0
        move.w (A0)+,d1   ;X
        move.w (A0)+,d2  ;Y
        move.w (A0)+,d3   ;dX
        move.w (A0)+,d4  ;dY
        sub.w d3,d1
        sub.w d4,d2
        move.w d1,(A0)+
        move.w d2,(A0)+
        move.w d3,(A0)+
        move.w d4,(A0)
        addq #1,d0
        move.w d0,N
        ;end of creating*       
 
;change smartness when feed is eaten in smart mode
        tst.b smart
        beq nosmart2
        DELAY 7
        bra sss

nosmart2    
        
        
            
continue   
        DELAY 7
        RTS  
 
clrScreen    
    move.l  #BLACK,d1   
    move.b  #80,d0  set pen color
    trap #15     

    move.l  #BLACK,d1   
    move.b  #81,d0  set fill color
    trap #15
    
    move.w  #0,d1      LX       black screen
    move.w  #0,d2      UY 
    move.w  #1280,d3   RX 
    move.w  #800,d4     LY 
    move.b  #87,d0     draw filled rectangle
    trap #15
    
    ;lines
    clr.l d0
    move.b grid,d0
    beq nogrid
    ;for lines
    move.l  #TEAL,d1   
    move.b  #80,d0  set pen color
    trap #15     

    move.l  #TEAL,d1   
    move.b  #81,d0  set fill color
    trap #15
    
    move.w  #0,d2      Y1 
    move.w  #800,d4     Y2
    move.w  #0,d1      X1       
    move.w  #0,d3   X2

nextline
    add.w #snakeSquare,d1
    add.w #snakeSquare,d3
    move.b  #84,d0     draw line
    trap #15
    cmp.w #1280,d1
    bne nextline   
    ;horizantal line
    move.w  #0,d1      X1 
    move.w  #1280,d3     X2
    move.w  #0,d2      Y1       
    move.w  #0,d4   Y2

nextlineh
    add.w #snakeSquare,d2
    add.w #snakeSquare,d4
    move.b  #84,d0     draw line
    trap #15
    cmp.w #800,d2
    bne nextlineh

nogrid
    RTS

    SIMHALT             ; halt simulator
  
      
* Put variables and constants here
smart dc.b 0
smartX dc.b 0
smartY dc.b 0
grid dc.b 0
missSound   dc.b    'miss.wav',0 
zeroSound   dc.b    '0.wav',0 
N DC.W 0
XF DC.W 0
YF DC.W 0
XFE DC.W 0
YFE DC.W 0
dXN DC.W 0
dYN DC.W 0
X DC.W 0
Y DC.W 0
deltaX DC.W 0
deltaY DC.W 0

snakeSquare EQU 20


BLACK   EQU    $00000000
MAROON  EQU    $00000080
GREEN   EQU    $00008000
OLIVE   EQU    $00008080
NAVY    EQU    $00800000
PURPLE  EQU    $00800080
TEAL    EQU    $00808000
GRAY    EQU    $00808080
RED     EQU    $000000FF
LIME    EQU    $0000FF00
YELLOW  EQU    $0000FFFF
BLUE    EQU    $00FF0000
FUCHSIA EQU    $00FF00FF
AQUA    EQU    $00FFFF00
LTGRAY  EQU    $00C0C0C0
WHITE   EQU    $00FFFFFF

    END    START        ; last line of source






*~Font name~Courier New~
*~Font size~18~
*~Tab type~1~
*~Tab size~4~
