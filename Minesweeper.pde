import de.bezier.guido.*;
int NUM_ROWS = 10;
int NUM_COLS=10;
private MSButton[][] buttons; //2d array of minesweeper buttons
private ArrayList <MSButton> mines; //ArrayList of just the minesweeper buttons that are mined
public boolean lost=false;

void setup ()
{
  size(400, 400);
  textAlign(CENTER, CENTER);
  buttons = new MSButton[NUM_ROWS][NUM_COLS];
  mines = new ArrayList<MSButton>();

  // make the manager
  Interactive.make( this );
  for (int i=0; i<NUM_ROWS; i++)
    for (int j=0; j<NUM_COLS; j++)
      buttons[i][j]=new MSButton(i, j);

  //your code to initialize buttons goes here



  setMines();
}
public void setMines()
{
  while (mines.size()<NUM_ROWS*NUM_COLS/5) {
    int rRow=(int)random(NUM_ROWS);
    int rCol = (int)random(NUM_COLS);
    MSButton rButton= buttons[rRow][rCol];
    if (!mines.contains(rButton)) mines.add(rButton);
  }
  //your code
}

public void draw ()
{
  background( 0 );
  if (isWon() == true)
    displayWinningMessage();
}
public boolean isWon()
{
   for (int r=0;r<NUM_ROWS;r++)
     for(int c=0;c<NUM_COLS;c++)
       if (buttons[r][c].flagged==false) return false;
  //your code here
  return true;
}
public void displayLosingMessage()
{
   for(int i=0;i<NUM_ROWS;i++)
     for(int j=0;j<NUM_COLS;j++)
       if (mines.contains(buttons[i][j])) buttons[i][j].clicked=true;
    lost=true;
    buttons[NUM_ROWS/2][NUM_COLS/2 - 5].setLabel("G"); 
    buttons[NUM_ROWS/2][NUM_COLS/2 - 4].setLabel("A"); 
    buttons[NUM_ROWS/2][NUM_COLS/2 - 3].setLabel("M"); 
    buttons[NUM_ROWS/2][NUM_COLS/2 - 2].setLabel("E"); 
    buttons[NUM_ROWS/2][NUM_COLS/2 + 1].setLabel("O"); 
    buttons[NUM_ROWS/2][NUM_COLS/2 + 2].setLabel("V"); 
    buttons[NUM_ROWS/2][NUM_COLS/2 + 3].setLabel("E");
    buttons[NUM_ROWS/2][NUM_COLS/2 + 4].setLabel("R"); 
  //your code here
}
public void displayWinningMessage()
{
   buttons[NUM_ROWS/2][NUM_COLS/2 - 5].setLabel("Y"); 
   buttons[NUM_ROWS/2][NUM_COLS/2 - 4].setLabel("O"); 
   buttons[NUM_ROWS/2][NUM_COLS/2 - 3].setLabel("U"); 
   buttons[NUM_ROWS/2][NUM_COLS/2 - 1].setLabel("W"); 
   buttons[NUM_ROWS/2][NUM_COLS/2].setLabel("I"); 
   buttons[NUM_ROWS/2][NUM_COLS/2 + 1].setLabel("N"); 
   buttons[NUM_ROWS/2][NUM_COLS/2 + 2].setLabel("!");
  //your code here
}
public boolean isValid(int r, int c)
{
  if (r>=0 && r<NUM_ROWS && c>=0 && c<NUM_COLS) return true;
  return false;
}
public int countMines(int row, int col)
{
  int numMines = 0;
  for (int i=row-1; i<=row+1; i++)
    for (int j=col-1; j<=col+1; j++)
      if (isValid(i, j)&&mines.contains(buttons[i][j])) numMines++;
  return numMines;
}
public class MSButton
{
  private int myRow, myCol;
  private float x, y, width, height;
  private boolean clicked, flagged;
  private String myLabel;

  public MSButton ( int row, int col )
  {
    width = 400/NUM_COLS;
    height = 400/NUM_ROWS;
    myRow = row;
    myCol = col; 
    x = myCol*width;
    y = myRow*height;
    myLabel = "";
    flagged = clicked = false;
    Interactive.add( this ); // register it with the manager
  }

  // called by manager
  public void mousePressed () 
  {
    clicked = true;
    if (mouseButton==RIGHT) {
      if (flagged)flagged=false;
    } else {
      flagged=false;
      clicked=false;
    }
    if (mines.contains(this)) {
      displayLosingMessage();
    } else if (countMines(myRow,myCol)>0) {
      flagged=true;
      setLabel(countMines(myRow,myCol));
    } else {
      for(int i=myRow-1;i<=myRow+1;i++)
        for(int j=myCol-1;j<=myCol+1;j++)
          if (i!=myRow||j!=myCol) 
            if (isValid(i,j)&&buttons[i][j].clicked==false) buttons[i][j].mousePressed();
    }

    //your code here
  }
  public void draw () 
  {    
    if (flagged)
      fill(0);
    else if ( clicked && mines.contains(this) ) 
      fill(255, 0, 0);
    else if (clicked)
      fill( 200 );
    else 
    fill( 100 );

    rect(x, y, width, height);
    fill(0);
    text(myLabel, x+width/2, y+height/2);
  }
  public void setLabel(String newLabel)
  {
    myLabel = newLabel;
  }
  public void setLabel(int newLabel)
  {
    myLabel = ""+ newLabel;
  }
  public boolean isFlagged()
  {
    return flagged;
  }
  
}
