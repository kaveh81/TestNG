import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.util.concurrent.TimeUnit;

import javax.management.RuntimeErrorException;

import org.apache.poi.hssf.usermodel.HSSFCell;
import org.apache.poi.hssf.usermodel.HSSFRow;
import org.apache.poi.hssf.usermodel.HSSFSheet;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.FormulaEvaluator;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.xssf.usermodel.XSSFCell;
import org.apache.poi.xssf.usermodel.XSSFRow;
import org.apache.poi.xssf.usermodel.XSSFSheet;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import org.apache.xalan.lib.sql.ObjectArray;
import org.openqa.selenium.By;
import org.openqa.selenium.Keys;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.firefox.FirefoxDriver;
import org.openqa.selenium.chrome.ChromeDriver;
import org.openqa.selenium.interactions.Actions;
import org.openqa.selenium.support.ui.ExpectedCondition;
import org.openqa.selenium.support.ui.WebDriverWait;
import org.testng.Assert;
import org.testng.SkipException;
import org.testng.annotations.AfterMethod;
import org.testng.annotations.AfterTest;
import org.testng.annotations.BeforeMethod;
import org.testng.annotations.BeforeTest;
import org.testng.annotations.DataProvider;
import org.testng.annotations.Test;
//------------------------------------------------------------------------------------------------------------------------------//
public class Validations {
private static WebDriver FireFoxdriver;
private static WebDriver ChromeDriver;
private static WebElement login;
private static WebElement password;
private static Actions action;
private static WebDriverWait wait;
private static File excel;
private static FileInputStream reader;
private static XSSFWorkbook workBook;
private static XSSFSheet sheet;
private static FormulaEvaluator formula;
String expectedResult;
String actualResult;
String  convertOne;
String  convertTwo;
String [][] twoDimArray = null;
String xlPath = "xlsFile//Workbook1.xls";
int xlsRow , xlsCoulm;

@BeforeTest
	public void beforeTest() {
		FireFoxdriver = new FirefoxDriver();
		//ChromeDriver = new  ChromeDriver();
		FireFoxdriver.get("https://facebook.com");
		action = new Actions(FireFoxdriver);
		wait = new WebDriverWait(FireFoxdriver, 5);
		FireFoxdriver.manage().timeouts().implicitlyWait(5, TimeUnit.SECONDS);
		
}
	@BeforeMethod()
	public void beforeMethod(){
		FireFoxdriver.manage().timeouts().implicitlyWait(5, TimeUnit.NANOSECONDS);
}
	
	@AfterMethod
	public void afterMethod(){
	
	}

	@Test(dataProvider="passingTest")
	public void testAuthPass(String l2 , String p2){
		//login
		login = FireFoxdriver.findElement(By.id("email"));
		login.clear();
		login.sendKeys(l2);
		
		//Password 
		password = FireFoxdriver.findElement(By.id("pass"));
	    password.sendKeys(p2);
		action.sendKeys(FireFoxdriver.findElement(By.id("u_0_2")),Keys.ENTER).build().perform();
		Assert.assertNotEquals(l2,p2);
}
	@Test(dataProvider= "fakeTest")
	public void testAuthFail (String l , String p){
		//login

		login = FireFoxdriver.findElement(By.id("email"));
		login.sendKeys(l);
		
		//Password
		password = FireFoxdriver.findElement(By.id("pass"));
		password.sendKeys(p);
		action.sendKeys(FireFoxdriver.findElement(By.id("u_0_x")),Keys.ENTER).build().perform();
		Assert.assertNotEquals(l,p);
		}
	
	@DataProvider (name = "passingTest")
	public Object[][] dataProvider()throws IOException{
		Object [][] passTest = new Object[1][2];
		excel = new File("xlsFile//Workbook2.xls");
		reader = new FileInputStream(excel);
		//Create a workbook instance that refers to .xls file
		workBook = new XSSFWorkbook(reader);
		//Create a sheet object to retrieve the sheet
		sheet = workBook.getSheet("Sheet1");
		//This is for evaluate the cell type
		formula = workBook.getCreationHelper().createFormulaEvaluator();
		
		xlsRow = sheet.getLastRowNum()+1;
		xlsCoulm = sheet.getRow(0).getLastCellNum();

		for (int i = 0; i< xlsRow ; i++){
			XSSFRow row = sheet.getRow(i);
			for(int j =0 ; j<xlsCoulm ; j++){
				XSSFCell cell = row.getCell(j);
				String Value = cell.toString();
				passTest[i][j]= Value;
				System.out.println("");
				
			}
		}
		return passTest;
}
	@DataProvider(name="fakeTest")
	public Object[][]dataProviderFail()throws IOException{	
		Object[][]failTest = new Object[10][2];
		    excel = new File("xlsFile//Workbook1.xls");
			reader = new FileInputStream(excel);
			//Create a workbook instance that refres to .xls file
			workBook = new XSSFWorkbook(reader);
			//Create a sheet object to reterive the shhet
			sheet = workBook.getSheet("Sheet1");
			//This is for evalute the cell type
			formula = workBook.getCreationHelper().createFormulaEvaluator();
			
			xlsRow = sheet.getLastRowNum()+1;
			xlsCoulm = sheet.getRow(0).getLastCellNum();
				
			for (int p = 0 ; p < xlsRow ; p++){
				XSSFRow row = sheet.getRow(p);
				for(int j = 0 ; j <xlsCoulm ; j++){
					
					XSSFCell cell = row.getCell(j);
					String Value = cell.toString();
					failTest[p][j]= Value;
					System.out.println("");
			}
		}

			return failTest;
				}
	
@AfterTest
	public void afterTest(){
		FireFoxdriver.close();
	}
	
}
