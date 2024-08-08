<!-- email = email i.e one and the same thing -->
<!-- convert to mysqli -->
<?php  
    require_once("config.php");
    session_start();
    $logged = false;
    //checking if anyone(admin/email)is logged in or not
    if(isset($_SESSION['logged']))
    {
        if ($_SESSION['logged'] == true)
        {
            $logged = true ;
            $email = $_SESSION['email'];
        }
    }
    else
        $logged=false;

    if($logged != true)
    {
        $email = "";
        if (isset($_POST['email']) && isset($_POST['pass']))
        {
            $email=$_POST['email'];
            $password=$_POST['pass'];            
            // some prereq-safeguards for the purpose of DB searching ->
            $email = stripslashes($email);
            $email = mysqli_real_escape_string($con,$email);
            $password = stripslashes($password);
            $password = mysqli_real_escape_string($con,$password);
        $flag = 1;
        $newsql = "SELECT pass from user WHERE email='$email'";
        $res = mysqli_query($con, $newsql);
        while ($newrow = mysqli_fetch_array($res)) {
            $p1 = $newrow['pass'];
            if(password_verify($password,$p1)){
                $flag=0;
            }
        }
        if ($flag == 0) {
            $sql = "SELECT * FROM user WHERE email='$email'";
            $result = mysqli_query($con, $sql);
            $row = mysqli_fetch_array($result, MYSQLI_ASSOC);
                $_SESSION['user'] = $row['name'];
                $_SESSION['logged'] = true;
                $_SESSION['uid'] = $row['id'];
                $_SESSION['email'] = $email;
                $_SESSION['account'] = "user";
                // echo "Yadpde";
                header("Location:user/index.php");
        }
        
            // admin
            $sql = "SELECT * FROM admin WHERE email='$email' AND pass='$password' ";
            $result = mysqli_query($con,$sql);
            $count = mysqli_num_rows($result);
            if ($count == 1) {
                $row=mysqli_fetch_array($result,MYSQLI_ASSOC);
                $_SESSION['logged']=true;
                $_SESSION['email'] = $email;
                $_SESSION['aid']=$row['id'];
                $_SESSION['account']="admin";
                header("Location:admin/index.php");
            }

        }
    }
?>