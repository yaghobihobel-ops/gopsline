<?php
class ItemIdentity
{

	public static function initializeIdentity($object)
	{						
		$resp = self::instantiateIdentity();				
		if(!$resp){
			Yii::app()->getController()->redirect( Yii::app()->createUrl('login/error') );	
			return false;
		}
		return true;
	}
	
	public static function instantiateIdentity()
	{			
		return true;
	}

	public static function addonIdentity($addon_name='')
	{
		$addon = AR_addons::model()->find("addon_name=:addon_name",[
			':addon_name'=>$addon_name
		]);
		if($addon){						
			return true;
		}
		throw new Exception("Addon not found");
	}
	
}
/*end class*/