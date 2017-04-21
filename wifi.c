/*  
 *  hello-1.c - The simplest kernel module.
 */
#include <linux/module.h>	/* Needed by all modules */
#include <linux/kernel.h>	/* Needed for KERN_INFO */
#include <linux/usb.h>


//#include <drv_conf.h>
//#include <basic_types.h>
//#include <osdep_service.h>
//#include <rtw_byteorder.h>
//#include <wlan_bssdef.h>
//#include <wifi.h>
//#include <ieee80211.h>

//#include <drv_types_linux.h>


MODULE_LICENSE("GPL");


/*
struct rtw_usb_drv {
	struct usb_driver usbdrv;
	int drv_registered;
	u8 hw_type;
};

struct rtw_usb_drv usb_drv = {
	.usbdrv.name =(char*)DRV_NAME,
	.usbdrv.probe = rtw_drv_init,
	.usbdrv.disconnect = rtw_dev_remove,
	.usbdrv.id_table = rtw_usb_id_tbl,
	.usbdrv.suspend =  rtw_suspend,
	.usbdrv.resume = rtw_resume,
	#if (LINUX_VERSION_CODE > KERNEL_VERSION(2, 6, 22))
  	.usbdrv.reset_resume   = rtw_resume,
	#endif
	#ifdef CONFIG_AUTOSUSPEND
	.usbdrv.supports_autosuspend = 1,
	#endif

	#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2, 6, 19))
	.usbdrv.drvwrap.driver.shutdown = rtw_dev_shutdown,
	#else
	.usbdrv.driver.shutdown = rtw_dev_shutdown,
	#endif
};
*/









static int usb_probe(struct usb_interface *pusb_intf, const struct usb_device_id *pdid)
{
  int status = 1;

  printk("usb plugged in\n");

  status = 0;
  
  //	_adapter *if1 = NULL, *if2 = NULL;
	/*	struct dvobj_priv *dvobj;
#ifdef CONFIG_MULTI_VIR_IFACES
	int i;
#endif //CONFIG_MULTI_VIR_IFACES

	printk("dog2\n");

	RT_TRACE(_module_hci_intfs_c_, _drv_err_, ("+rtw_drv_init\n"));
	//DBG_871X("+rtw_drv_init\n");

	//step 0.
	process_spec_devid(pdid);

	//Initialize dvobj_priv 
	if ((dvobj = usb_dvobj_init(pusb_intf)) == NULL) {
		RT_TRACE(_module_hci_intfs_c_, _drv_err_, ("initialize device object priv Failed!\n"));
		goto exit;
	}

	if ((if1 = rtw_usb_if1_init(dvobj, pusb_intf, pdid)) == NULL) {
		DBG_871X("rtw_usb_if1_init Failed!\n");
		goto free_dvobj;
	}

#ifdef CONFIG_CONCURRENT_MODE
	if((if2 = rtw_drv_if2_init(if1, usb_set_intf_ops)) == NULL) {
		goto free_if1;
	}
#ifdef CONFIG_MULTI_VIR_IFACES
	for(i=0; i<if1->registrypriv.ext_iface_num;i++)
	{
		if(rtw_drv_add_vir_if(if1, usb_set_intf_ops) == NULL)
		{
			DBG_871X("rtw_drv_add_iface failed! (%d)\n", i);
			goto free_if2;
		}
	}
#endif //CONFIG_MULTI_VIR_IFACES
#endif

#ifdef CONFIG_INTEL_PROXIM
	rtw_sw_export=if1;
#endif

#ifdef CONFIG_GLOBAL_UI_PID
	if(ui_pid[1]!=0) {
		DBG_871X("ui_pid[1]:%d\n",ui_pid[1]);
		rtw_signal_process(ui_pid[1], SIGUSR2);
	}
#endif

	//dev_alloc_name && register_netdev
	if((status = rtw_drv_register_netdev(if1)) != _SUCCESS) {
		goto free_if2;
	}

#ifdef CONFIG_HOSTAPD_MLME
	hostapd_mode_init(if1);
#endif

#ifdef CONFIG_PLATFORM_RTD2880B
	DBG_871X("wlan link up\n");
	rtd2885_wlan_netlink_sendMsg("linkup", "8712");
#endif

	RT_TRACE(_module_hci_intfs_c_,_drv_err_,("-871x_drv - drv_init, success!\n"));

	status = _SUCCESS;

free_if2:
	if(status != _SUCCESS && if2) {
		#ifdef CONFIG_CONCURRENT_MODE
		rtw_drv_if2_stop(if2);
		rtw_drv_if2_free(if2);
		#endif
	}
free_if1:
	if (status != _SUCCESS && if1) {
		rtw_usb_if1_deinit(if1);
	}
free_dvobj:
	if (status != _SUCCESS)
	usb_dvobj_deinit(pusb_intf); */
	//exit:
	return status == 0?0:-ENODEV; 
}







/*
 * dev_remove() - our device is being removed
*/
//rmmod module & unplug(SurpriseRemoved) will call r871xu_dev_remove() => how to recognize both
static void usb_dev_remove(struct usb_interface *pusb_intf)
{
  printk("usb removed\n");
  /*	struct dvobj_priv *dvobj = usb_get_intfdata(pusb_intf);
	struct pwrctrl_priv *pwrctl = dvobj_to_pwrctl(dvobj);
	_adapter *padapter = dvobj->if1;
	struct net_device *pnetdev = padapter->pnetdev;
	struct mlme_priv *pmlmepriv= &padapter->mlmepriv;

_func_enter_;

	DBG_871X("+rtw_dev_remove\n");
	RT_TRACE(_module_hci_intfs_c_,_drv_err_,("+dev_remove()\n"));

	dvobj->processing_dev_remove = _TRUE;

	rtw_unregister_netdevs(dvobj);

	if(usb_drv.drv_registered == _TRUE)
	{
		//DBG_871X("r871xu_dev_remove():padapter->bSurpriseRemoved == _TRUE\n");
		padapter->bSurpriseRemoved = _TRUE;
	}
	//else
	//{
		//DBG_871X("r871xu_dev_remove():module removed\n");
	//	padapter->hw_init_completed = _FALSE;
	//}


#if defined(CONFIG_HAS_EARLYSUSPEND) || defined(CONFIG_ANDROID_POWER)
	rtw_unregister_early_suspend(pwrctl);
#endif

	rtw_pm_set_ips(padapter, IPS_NONE);
	rtw_pm_set_lps(padapter, PS_MODE_ACTIVE);

	LeaveAllPowerSaveMode(padapter);

#ifdef CONFIG_CONCURRENT_MODE
#ifdef CONFIG_MULTI_VIR_IFACES
	rtw_drv_stop_vir_ifaces(dvobj);
#endif //CONFIG_MULTI_VIR_IFACES
	rtw_drv_if2_stop(dvobj->if2);
#endif //CONFIG_CONCURRENT_MODE

	#ifdef CONFIG_BT_COEXIST
	rtw_btcoex_HaltNotify(padapter);
	#endif

	rtw_usb_if1_deinit(padapter);

#ifdef CONFIG_CONCURRENT_MODE
#ifdef CONFIG_MULTI_VIR_IFACES
	rtw_drv_free_vir_ifaces(dvobj);
#endif //CONFIG_MULTI_VIR_IFACES
	rtw_drv_if2_free(dvobj->if2);
#endif //CONFIG_CONCURRENT_MODE

	usb_dvobj_deinit(pusb_intf);

	RT_TRACE(_module_hci_intfs_c_,_drv_err_,("-dev_remove()\n"));
	DBG_871X("-r871xu_dev_remove, done\n");


#ifdef CONFIG_INTEL_PROXIM
	rtw_sw_export=NULL;
#endif

_func_exit_;
*/
	return;

}







////////////////////////////////////////////
//
//#include <linux/module.h>
//#include <linux/kernel.h>
//#include <linux/usb.h>
// 
//static int pen_probe(struct usb_interface *interface, const struct usb_device_id *id)
//{
//    printk(KERN_INFO "Pen drive (%04X:%04X) plugged\n", id->idVendor, id->idProduct);
//    return 0;
//}
// 
//static void pen_disconnect(struct usb_interface *interface)
//{
//    printk(KERN_INFO "Pen drive removed\n");
//}
// 
//static struct usb_device_id pen_table[] =
//{
//    { USB_DEVICE(0x058F, 0x6387) },
//    {} /* Terminating entry */
//};
//MODULE_DEVICE_TABLE (usb, pen_table);
// 
//static struct usb_driver pen_driver =
//{
//    .name = "pen_driver",
//    .id_table = pen_table,
//    .probe = pen_probe,
//    .disconnect = pen_disconnect,
//};
// 
//static int __init pen_init(void)
//{
//    return usb_register(&pen_driver);
//}
// 
//static void __exit pen_exit(void)
//{
//    usb_deregister(&pen_driver);
//}
// 
//module_init(pen_init);
//module_exit(pen_exit);
// 
//MODULE_LICENSE("GPL");
//MODULE_AUTHOR("Anil Kumar Pugalia <email_at_sarika-pugs_dot_com>");
//MODULE_DESCRIPTION("USB Pen Registration Driver");

///////////////////////////////////////////////





static struct usb_device_id usb_id_table[] ={

	{USB_DEVICE(0x0B05, 0x184c),.driver_info = 1},
	{}
};

static struct usb_driver usb_driver = {
  //  .owner = "qq", //THIS_MODULE,
    .name = "skeleton",
    .id_table = usb_id_table,
    .probe = usb_probe,
    .disconnect = usb_dev_remove,
};


int init_module(void)
//int usb_register_driver(void)
{
	int ret = 0;

	printk(KERN_INFO "Hello world 1.\n");


	//usb_drv.drv_registered = _TRUE;
	//rtw_suspend_lock_init();
	//rtw_drv_proc_init();
	//rtw_ndev_notifier_register();

	ret = usb_register(&usb_driver);

	if (ret != 0) {
	  printk("error registering usb driver\n");
	  //usb_drv.drv_registered = _FALSE;
	  //rtw_suspend_lock_uninit();
	  //rtw_drv_proc_deinit();
	  //rtw_ndev_notifier_unregister();
	  goto exit;
	}

exit:
	return ret;













	
	/* 
	 * A non 0 return means init_module failed; module can't be loaded. 
	 */
	return 0;
}

void cleanup_module(void)
{
	printk(KERN_INFO "Goodbye world 1.\n");
	usb_deregister(&usb_driver);
}
