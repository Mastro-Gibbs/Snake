*---------------------------------------------------------------------------
* Program Version : 1.3.2
* Written By      : Stefano Fattore
* Date Created    : 16/05/2020
* Last Update     : 08/06/2020
* Description     : Il simpatico gioco del serpente e la mela
*
*---------------------------------------------------------------------------

        ORG    $1000
        
*====== COLORS ======*
       
JUNGLE  EQU    $00347C2C  (JUNGLE GREEN)
COPPER  EQU    $002B65EC
FIRE    EQU    $001728F6  (LITE RED)
LBROWN  EQU    $002B90EC
DRAGOON EQU    $0001D8FF  (STRANGE YELLOW)
RED     EQU    $000000FF
BLACK   EQU    $00000000
YELLOW  EQU    $0000FFFF
PURPLE  EQU    $00800080  
BTGRAY  EQU    $00828484  (BATTLESHIP GRAY)
LCYAN   EQU    $00FFCA82  (VERY LIGHT CYAN)
IRIDIUM EQU    $002A3C3D  (DARK GREEN-GRAY)


*====== CO-ORDINATES ======*
 
CENTRE  EQU    $00001106  (CURSOR ON SCREEN CENTRE)
CENTRE2 EQU    $00001108  (CURSOR ON SCREEN CENTRE-BOTTOM)
CENTRE3 EQU    $00001504  (USED FOR CURRENT SCORE CURSOR POSITION)
CENTRE4 EQU    $00001A01  (USED FOR RECORD SCORE CURSOR POSITION)
RECT1   EQU    $00000700  (CURSOR UP IN FIRST RECTCANGLE)
RECT1B  EQU    $00000702  (CURSOR DOWN IN FIRST RECTCANGLE)
RECT2   EQU    $00001B00  (CURSOR UP IN SECOND RECTCANGLE)
RECT2B  EQU    $00001D02  (CURSOR DOWN IN SECOND RECTCANGLE)
RECT3   EQU    $00002C00  (CURSOR UP IN THIRD RECTCANGLE)
RECT3B  EQU    $00003102  (CURSOR DOWN IN THIRD RECTCANGLE)
RECT4   EQU    $00004300  (CURSOR UP IN FOURTH RECTCANGLE)
RECT4B  EQU    $00004302  (CURSOR DOWN IN FOURTH RECTCANGLE)
CLEAN   EQU    $0000FF00  (CLEAN THE SCREEN INTERFACE)

*========= FONTS =========*

STDFONT EQU    $01090000  (STANDARD FONT MOTOROLA CODE 68000)
FONT1   EQU    $06180011  (CUSTOM FONT)




START  


*===== LOAD && PLAY MUSIC =====*
    
    LEA     GAMEMUSIC,A1 |  LOAD GAME MUSIC
    MOVE.B  #71,D0       |
    TRAP    #15          |
    MOVE.L  #1,D2        |
    MOVE.B  #76,D0       | PLAY GAME MUSIC IN LOOP WITH D2.L = 1
    TRAP    #15          |
    
        
*===== DEFAULT VALUES =====*
    *SET TO #0 FOR ALL AND #1 TO GOLDEN APPLE TO START WITH IT
    LEA     EATEN,A0
    MOVE.B  #0,(A0)
    LEA     SCORE,A0
    MOVE.W  #0,(A0)
    LEA     GOLDEN,A0
    MOVE.B  #1,(A0)
    
    *SET STARNDARD FONT, CUSTOM COLOR
    MOVE.L  #LCYAN,D1
    MOVE.L  #STDFONT,D2
    MOVE.B  #21,D0
    TRAP    #15
    
    *CLOSE ALL OPENED FILES
    MOVE.B  #50,D0    
    TRAP    #15
    

*=============== DRAWING GRAPHIC INTERFACE ================*
    
    *BACKGROUND
    MOVE.L  #JUNGLE,D1
    MOVE.B  #81,D0
    TRAP    #15
    MOVE.W  #0,D1
    MOVE.W  #0,D2
    MOVE.B  #89,D0
    TRAP    #15

*=============== DRAWING FIRST FRAME ================*

    *SET FIRST WALL COLOR
    MOVE.L	#COPPER,D1	
	MOVE.B	#80,D0
	TRAP	#15
	MOVE.B	#10,D1 *-----> WIDTH PARAMETER
	MOVE.B	#93,D0
	TRAP	#15
	
    *DRAWING 4 FIRST WALLS
	MOVE.W	#5,D1    *-----> LEFT
	MOVE.W	#58,D2
	MOVE.W	#5,D3
	MOVE.W	#480,D4
	MOVE.B	#87,D0
	TRAP	#15
	
	MOVE.W	#0,D1    *-----> UPPER
	MOVE.W	#65,D2
	MOVE.W	#640,D3
	MOVE.W	#65,D4
	MOVE.B	#87,D0
	TRAP	#15
	
    MOVE.W	#633,D1  *-----> RIGTH
	MOVE.W	#480,D2
	MOVE.W	#635,D3
	MOVE.W	#62,D4
	MOVE.B	#87,D0
	TRAP	#15
	
	MOVE.W	#0,D1    *-----> LOWER
	MOVE.W	#473,D2
	MOVE.W	#640,D3
	MOVE.W	#480,D4
	MOVE.B	#87,D0
	TRAP	#15
	
*=============== FIRST LINES IN THE FIRST FRAME DRAWING SECTION  ===============*
	
	*SET LINE COLOR
	MOVE.L  #BLACK,D1
	MOVE.B  #80,D0
	TRAP    #15
	MOVE.B	#1,D1 *-----> WIDTH PARAMETER
	MOVE.B	#93,D0
	TRAP	#15

	*DRAW  FIRST LINE
	MOVE.W	#9,D1    *-----> LEFT LINE
	MOVE.W	#58,D2
	MOVE.W	#9,D3
	MOVE.W	#480,D4
	MOVE.B	#84,D0
	TRAP	#15
	
	MOVE.W	#10,D1    *-----> UPPER LINE
	MOVE.W	#69,D2
	MOVE.W	#628,D3
	MOVE.W	#69,D4
	MOVE.B	#84,D0
	TRAP	#15
	
    MOVE.W	#628,D1  *-----> RIGTH LINE
	MOVE.W	#480,D2
	MOVE.W	#628,D3
	MOVE.W	#60,D4
	MOVE.B	#84,D0
	TRAP	#15
	
	MOVE.W	#10,D1    *-----> LOWER LINE
	MOVE.W	#468,D2
	MOVE.W	#628,D3
	MOVE.W	#468,D4
	MOVE.B	#84,D0
	TRAP	#15
	
*========= SINGLE BRICK DRAWING SECTION IN THE FIRST FRAME ==========*
	
	MOVE.W  #480,D5
	MOVE.W	#60,D2
	MOVE.W	#60,D4
LOOP_LEFT          *-----> LEFT BRICK
    MOVE.W	#0,D1    
	MOVE.W	#9,D3
	MOVE.B	#84,D0
	TRAP	#15
	ADD.W   #20,D2
	ADD.W   #20,D4
	SUB.W   #20,D5
	CMP.W   #60,D5
	BGE     LOOP_LEFT
	
	MOVE.W  #480,D5
	MOVE.W	#60,D2
	MOVE.W	#60,D4
LOOP_RIGHT         *-----> RIGHT BRICK
    MOVE.W	#628,D1    
	MOVE.W	#640,D3
	MOVE.B	#84,D0
	TRAP	#15
	ADD.W   #20,D2
	ADD.W   #20,D4
	SUB.W   #20,D5
	CMP.W   #60,D5
	BGE     LOOP_RIGHT
	
	MOVE.W  #640,D5
	MOVE.W	#9,D1    
	MOVE.W	#9,D3
LOOP_UPPER         *-----> UPPER BRICK
	MOVE.W	#60,D2
	MOVE.W	#69,D4
	MOVE.B	#84,D0
	TRAP	#15
	ADD.W   #20,D1
	ADD.W   #20,D3
	SUB.W   #20,D5
	CMP.W   #20,D5
	BGT     LOOP_UPPER
	
	MOVE.W  #640,D5
	MOVE.W	#9,D1   
	MOVE.W	#9,D3
LOOP_LOWER         *-----> LOWER BRICK
	MOVE.W	#468,D2
	MOVE.W	#480,D4
	MOVE.B	#84,D0
	TRAP	#15
	ADD.W   #20,D1
	ADD.W   #20,D3
	SUB.W   #20,D5
	CMP.W   #20,D5
	BGT     LOOP_LOWER
	

*============== DRAWING SECOND FRAME ================*	
	
    *SET SECOND WALL COLOR	
	MOVE.L	#LBROWN,D1	
	MOVE.B	#80,D0
	TRAP	#15
	MOVE.B	#9,D1 *------> WIDTH PARAMETER
	MOVE.B	#93,D0
	TRAP	#15
	
    *DRAWING 4 SECOND WALLS
    MOVE.W	#14,D1   *-----> LEFT
	MOVE.W	#70,D2
	MOVE.W	#14,D3
	MOVE.W	#468,D4
	MOVE.B	#87,D0
	TRAP	#15
	
	MOVE.W	#10,D1   *-----> UPPER
	MOVE.W	#74,D2
	MOVE.W	#628,D3
	MOVE.W	#74,D4
	MOVE.B	#87,D0
	TRAP	#15

    MOVE.W	#623,D1  *-----> RIGTH
	MOVE.W	#468,D2
	MOVE.W	#623,D3
	MOVE.W	#70,D4
	MOVE.B	#87,D0
	TRAP	#15
	
	MOVE.W	#10,D1   *-----> LOWER
	MOVE.W	#463,D2
	MOVE.W	#628,D3
	MOVE.W	#463,D4
	MOVE.B	#87,D0
	TRAP	#15
	
*========== SECOND LINES IN THE SECOND FRAME DRAWING SECTION ===========*
	
	*SET LINE COLOR
	MOVE.L  #BLACK,D1
	MOVE.B  #80,D0
	TRAP    #15
	MOVE.B	#1,D1 *-----> WIDTH PARAMETER
	MOVE.B	#93,D0
	TRAP	#15

	*DRAW  FIRST LINE
	MOVE.W	#18,D1    *-----> LEFT LINE
	MOVE.W	#69,D2
	MOVE.W	#18,D3
	MOVE.W	#468,D4
	MOVE.B	#84,D0
	TRAP	#15
	
	MOVE.W	#18,D1    *-----> UPPER LINE
	MOVE.W	#78,D2
	MOVE.W	#618,D3
	MOVE.W	#78,D4
	MOVE.B	#84,D0
	TRAP	#15
	
    MOVE.W	#619,D1   *-----> RIGTH LINE
	MOVE.W	#69,D2
	MOVE.W	#619,D3
	MOVE.W	#468,D4
	MOVE.B	#84,D0
	TRAP	#15
	
	MOVE.W	#18,D1    *-----> LOWER LINE
	MOVE.W	#459,D2
	MOVE.W	#618,D3
	MOVE.W	#459,D4
	MOVE.B	#84,D0
	TRAP	#15
	
*=========== SINGLE BRICK DRAWING SECTION IN THE SECOND FRAME ===========*
	
	MOVE.W  #460,D5
	MOVE.W	#69,D2
	MOVE.W	#69,D4
LOOP_LEFT2         *-----> LEFT BRICKS
    MOVE.W	#9,D1    
	MOVE.W	#18,D3
	MOVE.B	#84,D0
	TRAP	#15
	ADD.W   #20,D2
	ADD.W   #20,D4
	SUB.W   #20,D5
	CMP.W   #60,D5
	BGT     LOOP_LEFT2
	
	MOVE.W  #460,D5
	MOVE.W	#69,D2
	MOVE.W	#69,D4
LOOP_RIGHT2        *-----> RIGHT BRICKS
    MOVE.W	#619,D1    
	MOVE.W	#628,D3
	MOVE.B	#84,D0
	TRAP	#15
	ADD.W   #20,D2
	ADD.W   #20,D4
	SUB.W   #20,D5
	CMP.W   #60,D5
	BGT     LOOP_RIGHT2
	
	MOVE.W  #620,D5
	MOVE.W	#18,D1    
	MOVE.W	#18,D3
LOOP_UPPER2        *-----> UPPER BRICKS
	MOVE.W	#69,D2
	MOVE.W	#78,D4
	MOVE.B	#84,D0
	TRAP	#15
	ADD.W   #20,D1
	ADD.W   #20,D3
	SUB.W   #20,D5
	CMP.W   #20,D5
	BGT     LOOP_UPPER2
	
	MOVE.W  #620,D5
	MOVE.W	#18,D1    
	MOVE.W	#18,D3
LOOP_LOWER2        *-----> LOWER BRICKS
	MOVE.W	#459,D2
	MOVE.W	#468,D4
	MOVE.B	#84,D0
	TRAP	#15
	ADD.W   #20,D1
	ADD.W   #20,D3
	SUB.W   #20,D5
	CMP.W   #20,D5
	BGT     LOOP_LOWER2

*======= BLACK UPPER BOX DRAWING SECTION ========*
	
    *DRAW UPPER RECTANGLE	
	MOVE.L	#IRIDIUM,D1	
	MOVE.B	#80,D0
	TRAP	#15
	MOVE.L  #IRIDIUM,D1
	MOVE.B  #81,D0
	TRAP    #15
	MOVE.B	#1,D1 *------> WIDTH PARAMETER
	MOVE.B	#93,D0
	TRAP	#15
	
    *SET COORD FOR DRAWING 
    MOVE.W	#0,D1  
	MOVE.W	#0,D2
	MOVE.W	#640,D3
	MOVE.W	#60,D4
	MOVE.B	#87,D0
	TRAP	#15
	
*========== STRING POSITION AND PRINT; SCORE, APPLE, GOLDEN APPLE AVAILABILITY, RECORD POSITION AND PRINT =========*
    
    *FIRST SLOT ( GAME SCORE )
    MOVE.L  #RECT1,D1
    MOVE.B  #11,D0
    TRAP    #15
    LEA     SCORESTR,A1
    MOVE.B  #14,D0
    TRAP    #15
    MOVE.L  #RECT1B,D1
    ADDI.W  #$200,D1
    MOVE.B  #11,D0
    TRAP    #15
    LEA     SCORE,A0
    CLR.L   D1
    MOVE.B  (A0),D1
    MOVE.B  #3,D0
    TRAP    #15
    
    *SECOND SLOT ( EAT APPLES )
    MOVE.L  #RECT2,D1
    MOVE.B  #11,D0
    TRAP    #15
    LEA     APPLESTR,A1
    MOVE.B  #14,D0
    TRAP    #15
    MOVE.L  #RECT2B,D1
    MOVE.B  #11,D0
    TRAP    #15
    LEA     EATEN,A0
    CLR.L   D1
    MOVE.B  (A0),D1
    MOVE.B  #3,D0
    TRAP    #15
    
    *THIRD SLOT ( GOLDEN APPLE AVAILABILITY )
    MOVE.L  #RECT3,D1
    MOVE.B  #11,D0
    TRAP    #15
    LEA     GOLDENSTR,A1
    MOVE.B  #14,D0
    TRAP    #15
    MOVE.L  #RECT3B,D1
    MOVE.B  #11,D0
    TRAP    #15
    LEA     GOLDEN,A0
    CLR.L   D1
    MOVE.B  (A0),D1
    MOVE.B  #3,D0
    TRAP    #15
    
    *FOURTH SLOT ( GAME RECORD )
    MOVE.L  #RECT4,D1
    MOVE.B  #11,D0
    TRAP    #15
    LEA     RECORDSTR,A1
    MOVE.B  #14,D0
    TRAP    #15
    MOVE.L  #RECT4B,D1
    MOVE.B  #11,D0
    TRAP    #15
    
    LEA     FILENAME,A1   | LOAD FILE IN A1
    MOVE.B  #51,D0        | 
    TRAP    #15           | 
    
    LEA     BUFFER,A1 | LOAD STORAGE ADDRESS
    MOVE.L  #6,D2     | NUMBER BYTES TO READ IN THE FILE
    MOVE.B  #53,D0    | 
    TRAP    #15       |
    
    MOVE.B  #6,D1     | N CHAR TO DISPLAY
    MOVE.B  #1,D0     | TRAP TASK #1 WITHOUT CRLF TO PRINT N CHAR
    TRAP    #15

*===== DRAWING 3 LINES TO SEPARATE THE BLACK RECTANGLE INTO 4 BLOCKS SECTION =====*
   
    MOVE.L  #BTGRAY,D1 *--> SET LINE COLOR
    MOVE.B  #80,D0
    TRAP    #15
    
    *FIRST LINE
    MOVE.W  #160,D1
    MOVE.W  #0,D2
    MOVE.W  D1,D3
    MOVE.W  #59,D4
    MOVE.B  #84,D0
    TRAP    #15
    
    *SECOND LINE
    MOVE.W  #320,D1
    MOVE.W  #0,D2
    MOVE.W  D1,D3
    MOVE.W  #59,D4
    MOVE.B  #84,D0
    TRAP    #15
    
    *THIRD LINE
    MOVE.W  #480,D1
    MOVE.W  #0,D2
    MOVE.W  D1,D3
    MOVE.W  #59,D4
    MOVE.B  #84,D0
    TRAP    #15
    
*================= SNAKE AND APPLE DRAWER FOR FIRST TIME SECTION =================*
	
    MOVE.L  #DRAGOON,D1  *----> SET PEN COLOR  
    MOVE.B  #80,D0
    TRAP    #15
    MOVE.L  #PURPLE,D1  *----> SET FILL COLOR 
    MOVE.B  #81,D0
    TRAP    #15
    MOVE.W  #3,D1  *---------> SET WIDTH PEN 
    MOVE.B  #93,D0
    TRAP    #15
    
    CLR.B   D0          | LOOP FOR FILL SNAKE BLOCKS MEMORY
    MOVE.B  #100,D0      |
    LEA     MIDDLE,A0   |
FILL                   *|
    MOVE.W  #700,(A0)+  |
    SUB.B   #1,D0       |
    BNE     FILL        |
    MOVE.W  #4,SIZE     | SET TO 2 BLOCKS
    
    LEA     CURRENT,A0          | DYSPLAY SNAKE HEAD
    MOVE.W  #20,(A0)+           |
    MOVE.W  #80,(A0)           |
    LEA     CURRENT,A0          | RELOAD CURRENT FOR DRAW HIS HEAD IN LABEL 'SQUARES'
    BSR     SNAKE_SQUARE_DRAWER |  
     
    LEA     MIDDLE,A0   |
    MOVE.W  #100,(A0)+   | STARTING DISPLAYING SNAKE BLOCKS 
    MOVE.W  #100,(A0)    |
    
    BSR     FIND_APPLE > DISPLAY FIRST APPLE
  
    MOVE.W  #0,D6   | SET SNAKE MOVEMENT PIXELS
    MOVE.W  #20,D7  |
    
    MOVE.L  #25,SPEED *----> STARTING SPEED VALUE

    MOVE.B  #0,D1   |
    MOVE.B  #12,D0  | SET ECHO KAYBOARD
    TRAP    #15     |

    MOVE.B  #8,D0   |
    TRAP    #15     | TIME IN D5
    MOVE.L  D1,D5   |
    
*============================== GAME LOOP =============================*
    
LOOP
    MOVE.B  #8,D0       | NEED LOOP FOR STABILIZE SNAKE SPEED WITH TIME
    TRAP    #15         |
    SUB.L   D5,D1       |
    CMP.L   SPEED,D1    | IF TIME IS LESS THAN SPEED, UN HUNDREDTHS HAS PASSED
    BLO     LOOP        | LOOP UNTIL IT HAS
    TRAP    #15         | 
    MOVE.L  D1,D5       | RE-GET TIME FOR NEXT LOOP
    
SKIP
    LEA     OLD,A0      | COPY THE SNAKE TAIL IN TO <OLD> TO ERASE IT LATER
    LEA     MIDDLE,A1   |
    CLR.L   D4          |
    MOVE.W  SIZE,D4     | 
    SUB.W   #4,D4       |
    ADDA.L  D4,A1       |
    MOVE.W  (A1)+,(A0)+ |
    MOVE.W  (A1),(A0)   |
    
    LEA     MIDDLE,A0   | LOAD SKAKE BODY INTO MEMORY
    LEA     MIDDLE,A1   |
    ADDA.L  #200,A0     | 
    ADDA.L  #196,A1     |
    CLR.L   D4          |
    MOVE.B  #98,D4      |
   
COPY
    MOVE.W  -(A1),-(A0) | MOVE SQUARES BACK ONE 
    SUB.B   #1,D4       | 
    BNE     COPY        |
    
    LEA     MIDDLE,A0   |
    LEA     CURRENT,A1  | MOVING CURRENT (SNAKE HEAD) SQUARE TO MIDDLE (BODY)
    MOVE.W  (A1)+,(A0)+ |
    MOVE.W  (A1),(A0)   |
    
    CLR.L   D1          |
    MOVE.B  #7,D0       |
    TRAP    #15         | TRAP TASK 7 IF A KEY HAS BEEN PRESSED
    TST.L   D1          |       
    BEQ     CONTINUE    | IF A KEY WASN'T PRESSED CONTINUE MOVING SNAKE
    
    MOVE.B  #5,D0     | KEY READING WITH TRAP TASK 5
    TRAP    #15       |
    CMP.B   #$53,D1   |
    BEQ     DOWN      |
    CMP.B   #$57,D1   | > UPPER KEYS 'WASD'  
    BEQ     UP        |
    CMP.B   #$41,D1   |
    BEQ     LEFT      |
    CMP.B   #$44,D1   |
    BEQ     RIGHT     |
    
    CMP.B   #$73,D1   |
    BEQ     DOWN      |
    CMP.B   #$77,D1   | > LOWER KEYS 'wasd'  
    BEQ     UP        |
    CMP.B   #$61,D1   |
    BEQ     LEFT      |
    CMP.B   #$64,D1   |
    BEQ     RIGHT     |
    
CONTINUE
    LEA     CURRENT,A0 *---> POSITION OF SNAKE HEAD IN D6 = X, D7 = Y
    ADD.W   D6,(A0)+
    ADD.W   D7,(A0)
    
    LEA     CURRENT,A0  |
    CMP.W   #20,(A0)    |    
    BLT     HITWALL     |
    CMP.W   #600,(A0)+  |
    BHI     HITWALL     | BLOCK FOR CHECK IF SNAKE HIT A WALL
    CMP.W   #80,(A0)    |
    BLT     HITWALL     |
    CMP.W   #440,(A0)   |
    BHI     HITWALL     |
    
    CLR.L   D4          | RELOADING SNAKE SIZE IN D4 
    MOVE.W  SIZE,D4     |

CHECKER_HIT_ITSELF
    CMP     #0,D4              | 
    BLE     CHECKER_EAT_APPLE  |
    SUB.L   #4,D4              |
    LEA     MIDDLE,A1          |
    LEA     CURRENT,A0         |
    ADDA.L  D4,A1              | BLOCK FOR CHECK IF SNAKE HIT HIMSELF, IT'S A LOOP
    CMP.W   (A1)+,(A0)+        |       FOR EACH SNAKE BODY PART
    BNE     CHECKER_HIT_ITSELF |
    CMP.W   (A1)+,(A0)+        |
    BNE     CHECKER_HIT_ITSELF |
    BRA     HIT_ITSELF         |
    
CHECKER_EAT_APPLE
    LEA     CURRENT,A0                   |
    LEA     APPLE,A1                     |
    CMP.W   (A0)+,(A1)+                  |
    BNE     REFILLER_SNAKE_AND_BACKTAIL  |
    CMP.W   (A0)+,(A1)+                  | SNAKE HEAD MEMLOC COMPARE WITH APPLE MEMLOC, IF COMBACES THE APPLE HAS BEEN EAT
    BNE     REFILLER_SNAKE_AND_BACKTAIL  | 
    BSR     SCORE_PRINT                  | DISPLAY NEW SCORE
    BSR     FIND_APPLE                   | BRANCH FOR DRAW A NEW APPLE
    CMP.W   #159,SIZE                    | IF SNAKE SIZE IS GREATHER, DON'T INCREASE LENGTH
    BHI     REFILLER_SNAKE_AND_BACKTAIL  |
    ADD.W   #4,SIZE                      | ADD SLOT SNAKE, IF IT'S LENGTH IS LESS THAN 20
    
REFILLER_SNAKE_AND_BACKTAIL
    MOVE.L  #DRAGOON,D1  *---> SET FILL BODY COLOR 
    MOVE.B  #80,D0
    TRAP    #15
    MOVE.L  #PURPLE,D1  *---> SET FILL PEN COLOR SNAKE
    MOVE.B  #81,D0
    TRAP    #15
    
    LEA     CURRENT,A0  *---> ADD A BLOCK FOR SNAKE WHERE IT NEED
    BSR     SNAKE_SQUARE_DRAWER
    
    MOVE.L  #JUNGLE,D1 *----> REFILL BLOCK BEHIND THE SNAKE TAIL
    MOVE.B  #80,D0
    TRAP    #15
    MOVE.L  #JUNGLE,D1  
    MOVE.B  #81,D0
    TRAP    #15
    LEA     OLD,A0
    BSR     SNAKE_SQUARE_DRAWER
    
    BRA     LOOP

DOWN                   *| 
    MOVE.W  #0,D6       |              
    MOVE.W  #20,D7      |
    BRA     CONTINUE    |
                       *|
UP                     *|
    MOVE.W  #0,D6       |
    MOVE.W  #-20,D7     |
    BRA     CONTINUE    |
                       *| BLOCK FOR THE MOVEMENT OF THE SNAKE HEAD
LEFT                   *|
    MOVE.W  #-20,D6     |
    MOVE.W  #0,D7       |
    BRA     CONTINUE    |
                       *|
RIGHT                  *|
    MOVE.W  #20,D6      |
    MOVE.W  #0,D7       |
    BRA     CONTINUE    |
      
FIND_APPLE   *-----------> COORD GENERATOR USING TIME LIKE A VARIABLE BASE
    CLR.L   D1          
    CLR.L   D2
    CLR.L   D3  
    MOVE.B  #8,D0 *-----> TIME IN D1  
    TRAP    #15 
    MOVE.W  D1,D2 *-----> COORD 'X'
    DIVU    #29,D2
    SWAP    D2
    MULU    #20,D2
    ADDI.L  #20,D2
    MOVE.B  #8,D0 *-----> TIME IN D1
    TRAP    #15
    MOVE.W  D1,D3 *-----> COORD 'Y
    DIVU    #21,D3
    SWAP    D3
    MULU    #20,D3
    ADDI.L  #20,D3
    
*APPLE && SNAKE COMPARER     
COMPARING
    LEA     MIDDLE,A1
    LEA     EATEN,A2
    MOVE.B  (A2),D0
    ADD.B   #1,D0
    MULS    #2,D0
RESTART
    CMP.W   (A1)+,D2
    BNE     CONTINUE_TEST
    CMP.W   (A1)+,D3
    BNE     CONTINUE_TEST
    BEQ     FIND_APPLE
    
CONTINUE_TEST 
    SUB.B   #1,D0
    TST.B   D0
    BNE     RESTART      
     
    CMP.W   #320,D2 *---> IF X COOR IS 320 MAYBE ITS A GOLDEN APPLE, BRANCH TO VERIFY
    BEQ     GOLDEN_APPLE_COORD
    
CHECK_Y     *--------------> CHECK IF Y COORD IS LOWER THAN 79 PIXELS
    CMP.W   #79,D3         * IF ITS TRUE INCREASE IT BY 60 PIXELS
    BGE     COORD_APPLE
    ADD.W   #60,D3
    
COORD_APPLE
    LEA     APPLE,A2
    MOVE.W  D2,(A2)+
    MOVE.W  D3,(A2)+
    MOVE.L  #FIRE,D1 *------> SET PEN COLOR APPLE (FIREBRICK)
    MOVE.B  #80,D0
    TRAP    #15
    MOVE.L  #COPPER,D1 *----> SET BODY FILL APPLE (RED)
    MOVE.B  #81,D0
    TRAP    #15
    BSR     APPLE_DRAWER
    RTS               
    
GOLDEN_APPLE_COORD
    CMP.W   #240,D3     *-----> CHECK Y COORD FOR CONFIRM IF IT'S A GOLDEN APPLE
    BNE     CHECK_Y
    LEA     GOLDEN,A3   *-----> CHECK IF A GOLDEN CAN BE DISPLAYED
    TST.B   (A3)
    BEQ     FIND_APPLE
    MOVE.L  #IRIDIUM,D1 *-----> BACKGROUND AVAILABILITY GOLDEN APPLE
    MOVE.B  #81,D0
    TRAP    #15
    SUBI.B  #1,(A3)     *-----> DECREASE AVAILABILITY GOLDEN APPLE
    MOVE.L  #RECT3B,D1
    MOVE.B  #11,D0
    TRAP    #15
    CLR.L   D1
    MOVE.B  (A3),D1
    MOVE.B  #3,D0
    TRAP    #15
    LEA     APPLE,A2
    MOVE.W  D2,(A2)+
    MOVE.W  D3,(A2)+
    MOVE.L  #YELLOW,D1 *------> SET PEN COLOR GOLDEN APPLE (YELLOW)
    MOVE.B  #80,D0
    TRAP    #15
    MOVE.L  #YELLOW,D1 *------> SET BODY FILL COLOR GOLDEN APPLE (YELLOW)
    MOVE.B  #81,D0
    TRAP    #15
    BSR     APPLE_DRAWER
    RTS   
                                      
    
    
    
*================= INCREASING SCORE, APPLE EATEN, GOLDEN APPLE ==============*
    
    
    
SCORE_PRINT    *-----------> LABEL FOR PRINT SCORE
    MOVE.L  #IRIDIUM,D1   *--> BACKGROUND STR NERO
    MOVE.B  #81,D0
    TRAP    #15
    CLR.L   D1
    MOVE.L  #RECT1B,D1
    MOVE.B  #11,D0
    TRAP    #15
    LEA     APPLE,A0
    CMP.W   #320,(A0)+ *--> X COORD FOR GOLDEN APPLE CHECK
    BEQ     SCORE_BONUS
    
NORMAL_SCORE
    LEA     SCORE,A0
    CMP.W   #3000,(A0)
    BGE     SCOREUP   *---> IF SCORE IS GREATHER THAN 3000, SCORE WILL INCREASED BY +500 POINT
    ADDI.W  #250,(A0) *---> +250 SCORE POINT
    MOVE.W  (A0),D1
    MOVE.B  #3,D0
    TRAP    #15
    LEA     APPLE,A0
    JMP     APPLESCORE
    
SCOREUP
    ADDI.W  #500,(A0) *---> +500 SCORE POINT LABEL
    MOVE.W  (A0),D1
    MOVE.B  #3,D0
    TRAP    #15
    JMP     APPLESCORE
    
SCORE_BONUS    *----------> LABEL FOR GOLDEN APPLE SCORE POINT INCREASE
    CMP.W   #240,(A0) *---> Y COORD FOR GOLDEN APPLE CHECK
    BNE     NORMAL_SCORE
    LEA     SCORE,A0
    ADDI.W  #10000,(A0)
    MOVE.W  (A0),D1
    MOVE.B  #3,D0
    TRAP    #15
     
APPLESCORE     *------------> LABEL FOR PRINT HOW MUCH APPLE WAS EATEN 
    LEA     EATEN,A0
    ADD.B   #1,(A0)  
    MOVE.L  #IRIDIUM,D1  *--> BACKGRAOUND STR NERO
    MOVE.B  #81,D0
    TRAP    #15
    CLR.L   D1
    MOVE.L  #RECT2B,D1
    MOVE.B  #11,D0
    TRAP    #15
    CLR.L   D1
    MOVE.B  (A0),D1
    MOVE.B  #3,D0
    TRAP    #15
    BSR     SPEED_INCREASING
    RTS   

    

*================= GAME OVER, LOADING STRINGS  ====================*


 
HIT_ITSELF
    *CUSTOM STRING OUTPUT
    MOVE.L  #COPPER,D1
    MOVE.L  #FONT1,D2
    MOVE.B  #21,D0
    TRAP    #15
    MOVE.L  #140,D1
    MOVE.L  #210,D2
    MOVE.B  #95,D0   *---------> STRING HIT HIMSELF
    LEA     HITBODYSTR,A1
    TRAP    #15
    
    MOVE.L  #200,D1 | 
    MOVE.B  #23,D0  | -----> DELAY 2.0 SEC 
    TRAP    #15     |
    
    BSR     STOP_MUSIC
    BRA     NEW_OR_NOT  *--> NEW GAME LABEL BRANCH 

HITWALL
    *CUSTOM STRING OUTPUT
    MOVE.L  #COPPER,D1
    MOVE.L  #FONT1,D2
    MOVE.B  #21,D0
    TRAP    #15
    MOVE.L  #140,D1
    MOVE.L  #210,D2
    MOVE.B  #95,D0   *---------> STRING HIT HIMSELF
    LEA     HITWALLSTR,A1
    TRAP    #15
    
    MOVE.L  #200,D1 | 
    MOVE.B  #23,D0  | *----> DELAY 2.0 SEC 
    TRAP    #15     |
    
    BSR     STOP_MUSIC
    
    
NEW_OR_NOT  *-------------> ASK FOR NEW GAME OR NOT
    LEA     MENUMUSIC,A1 | LOAD MENU MUSIC
    MOVE.B  #71,D0       |
    TRAP    #15          |
    MOVE.B  #1,D2        |
    MOVE.B  #76,D0       | PLAY MENU MUSIC ONCE
    TRAP    #15          |
     
    BSR     CLEAN_SR
    
    *CUSTOM STRING OUTPUT
    MOVE.L  #BTGRAY,D1
    MOVE.L  #FONT1,D2
    MOVE.B  #21,D0
    TRAP    #15
    MOVE.L  #8,D1
    MOVE.L  #190,D2
    MOVE.B  #95,D0   *---------> STRING CUSTOM
    LEA     NEW_NOTSTR,A1
    TRAP    #15 
    CLR.L   D1
    MOVE.W  #CENTRE,D1  *--> SET CURSOR ON CENTRE
    MOVE.B  #11,D0
    TRAP    #15        
    
    *CHECK WHICH KEY WILL BE PRESSED
    CLR.W   D1            |
    MOVE.B  #7,D0         |
    TRAP    #15           |
    MOVE.B  #5,D0         | 
    TRAP    #15           |
    CMP.B   #$59,D1       | ---> CHECK 'Y'
    BEQ     RESTORE       |
    CMP.B   #$79,D1       | ---> CHECK 'y'
    BEQ     RESTORE       |
    CMP.B   #$4E,D1       | ---> CHECK 'N'
    BEQ     STOP          |
    CMP.B   #$6E,D1       | ---> CHECK 'n' 
    BNE     NEW_OR_NOT    |
    BEQ     STOP          |
    
    
    
    
*============ LABEL WHO RESTORE THE GAME FOR RELAUNCH ============*


             
RESTORE     
    BSR     CLEAN_SR  *---------> SUB-ROUTINE TO CLEAN ALL AND REFILL WITH BLACK
    BSR     VIEW_SCORES  *------> PRINT CURRENT SCORE, RECORD AND ASK IF YOU WANT SAVE IT
    
    *CHECK WHICH KEY WILL BE PRESSED
    CLR.W   D1            |
    MOVE.B  #7,D0         |
    TRAP    #15           |
    MOVE.B  #5,D0         | 
    TRAP    #15           |
    CMP.B   #$59,D1       | ---> CHECK 'Y'
    BEQ     SAVING1       |
    CMP.B   #$79,D1       | ---> CHECK 'y'
    BEQ     SAVING1       |
    CMP.B   #$4E,D1       | ---> CHECK 'N'
    BEQ     NO_SAVE       |
    CMP.B   #$6E,D1       | ---> CHECK 'n' 
    BNE     NEW_OR_NOT    |
    BEQ     NO_SAVE       |
    BSR     CLEAN_SR      | SUB-ROUTINE TO CLEAN ALL AND REFILL WITH BLACK
    
SAVING1
    BSR     SAVER_SR *----> SUB-ROUTINE WHO WRITE THE FILE
    BSR     CLEAN_SR *----> SUB-ROUTINE TO CLEAN ALL AND REFILL WITH BLACK
    BSR     COUNTDOWN_SR *> SUB-ROUTINE TO COUNTDOWN THE SAVING
    
NO_SAVE
    BSR     CLEAN_SR *----> SUB-ROUTINE TO CLEAN ALL AND REFILL WITH BLACK
               
    *COUNTDOWN LOOP SECTION START HERE
    MOVE.L  #170,D1
    MOVE.L  #190,D2
    MOVE.B  #95,D0 
    LEA     STARTSTR,A1
    TRAP    #15
    MOVE.L  #3,D2
COUNTDOWN_LOOP
    MOVE.L  #CENTRE,D1  *--> SET CURSOR ON CENTRE
    MOVE.B  #11,D0
    TRAP    #15
    CLR.L   D1
    MOVE.B  D2,D1
    MOVE.B  #3,D0
    TRAP    #15
    MOVE.L  #100,D1    |
    MOVE.B  #23,D0     | DELAY 1 SEC 
    TRAP    #15        |
    SUB.B   #1,D2
    TST.B   D2
    BGT     COUNTDOWN_LOOP
    *COUNTDOWN LOOP SECTION STOP HERE
    
    BSR     CLEAN_SR *---> SUB-ROUTINE TO CLEAN ALL AND REFILL WITH BLACK
    BSR     STOP_MUSIC
    
    MOVE.L  #LCYAN,D1    | RESET FONT TO STANDARD
    MOVE.L  #STDFONT,D2  |
    MOVE.B  #21,D0       |
    TRAP    #15          |
    
    BSR     STOP_MUSIC
    
    JMP     START
    
    
     
  
*============ LABEL WHO SAVE THE RECORD AND STOP THE GAME ============*

STOP
    BSR     CLEAN_SR *---------> SUB-ROUTINE TO CLEAN ALL AND REFILL WITH BLACK
    BSR     VIEW_SCORES *------> PRINT CURRENT SCORE, RECORD AND ASK IF YOU WANT SAVE IT
    
    *CHECK WHICH KEY WILL BE PRESSED
    CLR.W   D1            |
    MOVE.B  #7,D0         |
    TRAP    #15           |
    MOVE.B  #5,D0         | 
    TRAP    #15           |
    CMP.B   #$59,D1       | ---> CHECK 'Y'
    BEQ     SAVING2       |
    CMP.B   #$79,D1       | ---> CHECK 'y'
    BEQ     SAVING2       |
    CMP.B   #$4E,D1       | ---> CHECK 'N'
    BEQ     STOP_E_NOSAVE |
    CMP.B   #$6E,D1       | ---> CHECK 'n' 
    BNE     NEW_OR_NOT    |
    BEQ     STOP_E_NOSAVE |
    
    BSR     CLEAN_SR *---------> SUB-ROUTINE TO CLEAN ALL AND REFILL WITH BLACK
    
SAVING2
    BSR     SAVER_SR *---------> SUB-ROUTINE WHO WRITE THE FILE
    BSR     CLEAN_SR *---------> SUB-ROUTINE TO CLEAN ALL AND REFILL WITH BLACK
    BSR     COUNTDOWN_SR *-----> SUB-ROUTINE TO COUNTDOWN THE SAVING

STOP_E_NOSAVE
    MOVE.L  #75,D1       |
    MOVE.B  #23,D0       | DELAY 0.75 SEC 
    TRAP    #15          | 
    
    BSR     CLEAN_SR *---------> SUB-ROUTINE TO CLEAN ALL AND REFILL WITH BLACK
   
    *BYE BYE STRING OUTPUT
    MOVE.L  #180,D1
    MOVE.L  #210,D2
    MOVE.B  #95,D0   *---------> STRING 'SEE YOU SOON'
    LEA     BYESTR,A1
    TRAP    #15
    
    BSR     STOP_MUSIC
    
    STOP    #$3000
    
*============ SOME ROUTINE LIKE CLEANER, SAVER, COUNTDOWNER ===========*

*SNAKE DRAWER SUB-ROUTINE
SNAKE_SQUARE_DRAWER              
    CLR.L   D1        | 
    CLR.L   D2        |
    CLR.L   D3        |
    CLR.L   D4        |
    MOVE.W  (A0)+,D1  |
    MOVE.W  (A0),D2   |
    MOVE.W  D1,D3     | --------> DRAW SNAKE IN COORD X,Y,X1,Y1
    ADD.W   #17,D3    |
    MOVE.W  D2,D4     |
    ADD.W   #17,D4    |
    MOVE.B  #87,D0    |
    TRAP    #15       |
    RTS               |


*APPLE DRAWER SUB-ROUTINE
APPLE_DRAWER
    LEA     APPLE,A0
    CLR.L   D1         
    CLR.L   D2        
    CLR.L   D3        
    CLR.L   D4        
    MOVE.W  (A0)+,D1  
    MOVE.W  (A0),D2   
    MOVE.W  D1,D3     
    ADD.W   #17,D3    
    MOVE.W  D2,D4     
    ADD.W   #17,D4             
    MOVE.B  #88,D0   
    TRAP    #15 
    RTS
    
*SPEED INCREASING SUB-ROUTINE
SPEED_INCREASING
    CMP.B   #20,D1
    BGE     HARD_MODE
    SUB.L   #1,SPEED   
HARD_MODE
    CMP.B   #35,D1
    BNE     EXTREME_MODE
    SUB.L   #2,SPEED
EXTREME_MODE
    CMP.B   #50,D1
    BNE     MAX_SPEED_REACHED
    SUB.L   #1,SPEED
MAX_SPEED_REACHED
    RTS
    
*MUSIC STOPPER SUB-ROUTINE
STOP_MUSIC
    MOVE.L  #3,D2        | CODE #3 IN D2.L IN D1.B
    MOVE.B  #76,D0       |
    TRAP    #15
    RTS

*DISPLAY CLEANER SUB-ROUTINE
CLEAN_SR   
    MOVE.L  #11,D0    
    MOVE.W  #CLEAN,D1
    TRAP    #15
    MOVE.L  #BLACK,D1
    MOVE.B  #81,D0
    TRAP    #15
    CLR.W   D1
    CLR.W   D2
    MOVE.B  #89,D0
    TRAP    #15
    RTS

*SAVING COUNTDOWNER SUB-ROUTINE    
COUNTDOWN_SR
    MOVE.L  #225,D1
    MOVE.L  #190,D2
    MOVE.B  #95,D0   *---------> STRING CUSTOM
    LEA     SAVINGSTR,A1
    TRAP    #15
    MOVE.L  #3,D2
COUNTDOWN_LOOPEND
    MOVE.L  #CENTRE,D1  *------> SET CURSOR ON CENTRE
    MOVE.B  #11,D0
    TRAP    #15
    CLR.L   D1
    MOVE.B  D2,D1
    MOVE.B  #3,D0
    TRAP    #15
    MOVE.L  #100,D1      |
    MOVE.B  #23,D0       | DELAY 1 SEC 
    TRAP    #15          |
    SUB.B   #1,D2
    TST.B   D2
    BGT     COUNTDOWN_LOOPEND
    RTS
    
*SCORE PRINTER SUB-ROUTINE  
VIEW_SCORES
    *YOUR SCORE STRING OUTPUT
    MOVE.L  #80,D1
    MOVE.L  #148,D2
    MOVE.B  #95,D0   *---------> STRING CUSTOM
    LEA     YOURSCORE,A1
    TRAP    #15
    MOVE.L  #3,D2
    MOVE.L  #CENTRE3,D1  *-----> SET CURSOR ON CENTRE
    MOVE.B  #11,D0
    TRAP    #15
    MOVE.L  #RED,D1
    MOVE.L  #FONT1,D2
    MOVE.B  #21,D0
    TRAP    #15
    LEA     SCORE,A0
    CLR.L   D1
    MOVE.W  (A0),D1
    MOVE.B  #3,D0
    TRAP    #15
    MOVE.L  #BTGRAY,D1
    MOVE.L  #FONT1,D2
    MOVE.B  #21,D0
    TRAP    #15
    
    *CURRENT RECORD STRING OUTPUT
    MOVE.L  #80,D1
    MOVE.L  #38,D2
    MOVE.B  #95,D0   *---------> STRING CUSTOM
    LEA     CURRENTSTR,A1
    TRAP    #15
    MOVE.L  #3,D2
    MOVE.L  #CENTRE4,D1  *-----> SET CURSOR ON CENTRE4
    MOVE.B  #11,D0
    TRAP    #15
    MOVE.L  #RED,D1
    MOVE.L  #FONT1,D2
    MOVE.B  #21,D0
    TRAP    #15
    LEA     FILENAME,A1   | LOAD FILE IN A1
    MOVE.B  #51,D0        | 
    TRAP    #15           | 
    LEA     BUFFER,A1     | LOAD STORAGE ADDRESS
    MOVE.L  #5,D2         | NUMBER BYTES TO READ IN THE FILE
    MOVE.B  #53,D0        | 
    TRAP    #15           |
    MOVE.B  #5,D1         | N CHAR TO DISPLAY
    MOVE.B  #1,D0         | TRAP TASK #1 WITHOUT CRLF TO PRINT N CHAR
    TRAP    #15
    MOVE.L  #BTGRAY,D1
    MOVE.L  #FONT1,D2
    MOVE.B  #21,D0
    TRAP    #15
          
    *SAVE ASKER STRING OUTPUT
    MOVE.L  #80,D1
    MOVE.L  #260,D2
    MOVE.B  #95,D0   *---------> STRING CUSTOM
    LEA     SAVESTR,A1
    TRAP    #15
    MOVE.L  #3,D2
    MOVE.L  #CENTRE2,D1  *-----> SET CURSOR ON CENTRE-BOTTOM
    MOVE.B  #11,D0
    TRAP    #15
    RTS
    
*SCORE SAVER SUB-ROUTINE 
SAVER_SR
    BSR     CLEAN_SR
    MOVE.B  #1,D1        |
    MOVE.B  #12,D0       | SET ECHO KAYBOARD
    TRAP    #15          |
    MOVE.L  #80,D1
    MOVE.L  #170,D2
    MOVE.B  #95,D0   *---------> STRING CUSTOM
    LEA     SAVERECORD,A1
    TRAP    #15
    MOVE.L  #3,D2
    MOVE.L  #CENTRE,D1  *------> SET CURSOR ON CENTRE
    MOVE.B  #11,D0
    TRAP    #15
    LEA     RECORD,A1
    MOVE.B  #2,D0
    TRAP    #15
    MOVEA   A1,A2
    LEA     FILENAME,A1   
    MOVE.B  #51,D0    
    TRAP    #15 
    MOVEA   A2,A1
    MOVE.B  #6,D2
    MOVE.B  #54,D0
    TRAP    #15
    MOVE.B  #56,D0
    TRAP    #15
    RTS
    
    

        SIMHALT
    
*RESEVED MEMORY FOR SNAKE*    
CURRENT DS.W    2
OLD     DS.W    2
MIDDLE  DS.W    100

*RESERVED MEMORY FOR SNAKE SPECIFICATIONS*
SIZE    DS.W    1
SPEED   DS.L    1

*RESERVED MEMORY FOR APPLE*
APPLE   DS.W    2

*RESERVED MEMORY FOR SCORES*
SCORE   DS.B    2
EATEN   DS.B    1
GOLDEN  DS.B    1

*SOUND AND FILE RESOURCE
GAMEMUSIC   DC.B    'SNAKE_MELODY_8BIT.wav',0
MENUMUSIC   DC.B    'SNAKE_MENU_8BIT.wav',0
FILENAME    DC.B    'RECORD.txt',0
BUFFER      DS.B    5  
RECORD      DS.B    5

*STRINGS
HITWALLSTR  DC.B     'YOU HAVE HIT A WALL!',0
HITBODYSTR  DC.B     'YOU HAVE EAT YOURSELF!',0
NEW_NOTSTR  DC.B     'WOULD YOU LIKE TO PLAY AGAIN? (Y/N)',0
BYESTR      DC.B     'SEE YOU SOON! :D',0 
RECORDSTR   DC.B     'RECORD',0
SCORESTR    DC.B     'SCORE',0
APPLESTR    DC.B     'APPLE',0
GOLDENSTR   DC.B     'GOLDEN APPLE',0
STARTSTR    DC.B     'GAME START IN...',0
SAVESTR     DC.B     'WOULD YOU SAVE THE RECORD?',0
SAVERECORD  DC.B     'INSERT THE CURRENT RECORD...',0
SAVINGSTR   DC.B     'SAVING IN...',0
YOURSCORE   DC.B     'YOUR SCORE IS... ',0
CURRENTSTR  DC.B     'THE CURRENT RECORD IS ',0

    END    START



*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
