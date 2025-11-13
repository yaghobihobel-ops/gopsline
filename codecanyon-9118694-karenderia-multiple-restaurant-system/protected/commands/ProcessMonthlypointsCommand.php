<?php
set_time_limit(0);

class ProcessMonthlypointsCommand extends CConsoleCommand
{
    public function actionIndex()
    {                
        CommonUtility::mysqlSetTimezone();        

        if (date('Y-m-d') === date('Y-m-t')) {
            //           
        } else {
            echo "Today is not the end of the month.";
        }

        $stmt = "
        SELECT 
            card_id,
            (COALESCE(SUM(CASE 
                            WHEN transaction_type NOT IN ('points_redeemed', 'debit') 
                            AND transaction_date BETWEEN DATE_FORMAT(CURDATE(), '%Y-%m-01') AND LAST_DAY(CURDATE())
                            THEN transaction_amount 
                            ELSE 0 
                        END), 0) - 
            COALESCE(SUM(CASE 
                            WHEN transaction_type IN ('points_redeemed', 'debit') 
                            AND transaction_date BETWEEN DATE_FORMAT(CURDATE(), '%Y-%m-01') AND LAST_DAY(CURDATE())
                            THEN transaction_amount 
                            ELSE 0 
                        END), 0)) AS total_available_points
        FROM {{wallet_transactions}} a

        WHERE card_id NOT IN (
           select card_id from {{wallet_transactions}}
           where card_id=a.card_id
           and transaction_date BETWEEN DATE_FORMAT(CURDATE(), '%Y-%m-01') AND LAST_DAY(CURDATE())
           and transaction_type='points_bonus'
           and status='paid'
        )

        GROUP BY 
            card_id
        ";
        if($res = Yii::app()->db->createCommand($stmt)->queryAll()){               
            foreach ($res as $items) {                
                $card_id = $items['card_id'];
                $balance = $items['total_available_points'];
                if($points = CPoints::getUserRedeemthresholds($balance,'monthly_thresholds')){                    
                    $extra_points = $points['redeeming_value']; 
                    $params = array(					  		 
                        'transaction_description'=>'Monthly bonus',
                        'transaction_description_parameters'=>'',
                        'transaction_type'=>'points_bonus',
                        'transaction_amount'=>floatval($extra_points),
                        'status'=>'paid',                                                        
                    );                   
                    try {
                        CWallet::inserTransactions($card_id,$params);
                    } catch (Exception $e) {}     
                }
            }
        }
    }
}
// end class