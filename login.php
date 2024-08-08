<!-- NOTE
SINGLE PAGE FORM ALONG WITH VALIDATION
NO PHP LEAKS BACK TO THE INDEX 
 -->
<?php
  require_once("Includes/config.php");
  require_once("Includes/session.php");
  /*if(!(isset($_POST['email']&&isset($_POST['pass'])))) {
    location('index.php');
  }*/
   // if ($count === 0) {
  // echo "There were some problem";
// }
  ?>
  <?php if(isset($_POST['signin'])){
                        $email     = mysqli_real_escape_string($con,$_POST['email']);    
                        $password  = mysqli_real_escape_string($con,$_POST['pass']);    
                        
                        $query = "SELECT * FROM user";
                        $run   = mysqli_query($con,$query);
                        
                        if(mysqli_num_rows($run) > 0 ){
                           while($row = mysqli_fetch_array($run)){

                            $db_id    = $row['id'];
                            $db_name  = $row['name'];
                            $db_email = $row['email'];
                            $db_pass  = $row['pass'];
                            $db_add   = $row['address'];
                            $db_phone= $row['phone'];

                            if($email == $db_email && $password == password_verify($password,$db_pass)){  // DEHASH
                                $_SESSION['id']    = $db_id;
                                $_SESSION['name']  = $db_name;
                                $_SESSION['email'] = $db_email;
                                $_SESSION['add']   = $db_add;
                                $_SESSION['phone']= $db_phone;
                                
                                header('location:user/index.php'); 

                            } 
                            else{
                              $error="Invalid Email or Password";
                            }
                           }
                          } 
                          else{
                            $error="This account doesn't exist";
                          }
                            
                         
                        
                      }
                        
                      ?>
                      
                         <?php
                      if(isset($error)){
                      
                        echo "<div class='alert bg-danger' role='alert'>
                                <span class='text-white text-center'> $error</span>
                                  <button type='button' class='close' data-dismiss='alert' aria-label='Close'>
                                    <span aria-hidden='true'>&times;</span>
                                  </button>
                              </div>";
                    
                        }
                      
                      ?>

<form action="index.php" class="navbar-form navbar-right" role="form" method="post">
    <div class="form-group">
        <input type="text" placeholder="Email" name="email" id="email" class="form-control">
    </div>
    <div class="form-group">
        <input type="password" placeholder="Password" name="pass" id="pass" class="form-control">
    </div>
    <button type="login_submit" name="signin" class="btn btn-success" onclick=" validateForm();">Sign In</button>
</form>

