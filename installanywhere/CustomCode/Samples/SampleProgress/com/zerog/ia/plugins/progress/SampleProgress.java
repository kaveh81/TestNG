/*
 * Created on Mar 30, 2006
 * 
 * Copyright (c) 2006 Macrovision Europe Ltd. and/or Macrovision Corporation.
 * All Rights Reserved.
 * 
 * This software has been provided pursuant to a License Agreement containing
 * restrictions on its use. This software contains valuable trade secrets and
 * proprietary information of Macrovision Corporation and is protected by law.
 * It may not be copied or distributed in any form or medium, disclosed to third
 * parties, reverse engineered or used in any manner not provided for in said
 * License Agreement except with the prior written authorization from
 * Macrovision Corporation.
 */

package com.zerog.ia.plugins.progress;

import com.zerog.ia.api.pub.CustomCodeAction;
import com.zerog.ia.api.pub.InstallException;
import com.zerog.ia.api.pub.InstallerProxy;
import com.zerog.ia.api.pub.ProgressAccess;
import com.zerog.ia.api.pub.UninstallerProxy;

/**
 * This action provides an example of code which leverages the progress API's
 * available within InstallerProxy and UinstallerProxy used to interact with the
 * progress archtiecture at runtime. The code within this sample shows a simple
 * implementation which integrates with the overall progress and manipulates the
 * status message.
 * <p>
 * NOTE: Actual behavior of the progress bar will differ based upon the context
 * in which this action is utilized. For example, within a pre-install sequence,
 * the action will own the entire progress processing, resulting in a
 * progression from 0 - 100% (actual visual details depend upon the settings of
 * the custom action itself - e.g. the "Show indeterminate dialog" setting,
 * etc.). Within the context of the install sequence, on the other hand, the
 * action will be a portion of the overall sequence, resulting in a progress
 * progression factored based upon the relative size of this action versus
 * others within the same install sequence (see the "estimated size" methods for
 * information).
 */
public class SampleProgress extends CustomCodeAction {

    public void install(InstallerProxy ip) throws InstallException {
        showProgress(ip);
    }

    public void uninstall(UninstallerProxy up) throws InstallException {
        showProgress(up);
    }

    public String getInstallStatusMessage() {
        return "Sample Progress";
    }

    public String getUninstallStatusMessage() {
        return getInstallStatusMessage();
    }

    /**
     * This method should return the estimated time, in tenths (1/10) of
     * seconds, to complete the install operation, given the action's current
     * state. This value is used to weigh the progress of multiple actions
     * during installation. <EM>This value is only an estimate and does not
     * have to be accurate to be effective</EM>.
     * <p>
     * For example, it could take one action several seconds to install a set of
     * files. It could take another action only a fraction of a second to
     * install and configure a desktop icon. If both action's progress were
     * weighted equally, e.g., each contributed 50% to the overall progress, the
     * progress bar would move steadily up to the 50% mark during the files
     * installation and then jump immediately to 100% during the desktop icon
     * installation. Even rough estimates of the action's time to install allows
     * progress to be charted more smoothly.
     * <p>
     * <EM>NOTE: Actions which claim to have a particular estimated time
     * <STRONG>must</STRONG> utilize the progress api's within the proxy
     * objects at install/uninstall time to account for their full progress.
     * Failure to do so will result in improper progress reporting within the
     * runtime GUI.</EM>
     * 
     * @param ip Provides access to designer-specified resources, system and
     *            user-defined variables, and international resources.
     * 
     * @return The estimated time to install this action (as described above).
     * 
     * @see com.zerog.ia.api.pub.InstallerProxy
     */
    public long getEstimatedTimeToInstall(InstallerProxy ip) {
        return 100;
    }

    /**
     * This method should return the estimated time, in tenths (1/10) of
     * seconds, to complete the uninstall operation, given the action's current
     * state. This value is used to weigh the progress of multiple action during
     * uninstallation. <EM>This value is only an estimate, and does not have to
     * be accurate to be effective</EM>.
     * <p>
     * <EM>NOTE: Actions which claim to have a particular estimated time
     * <STRONG>must</STRONG> utilize the progress api's within the proxy
     * objects at install/uninstall time to account for their full progress.
     * Failure to do so will result in improper progress reporting within the
     * runtime GUI.</EM>
     * 
     * @param up Provides access to designer-specified resources, system and
     *            user-defined variables, and international resources.
     * 
     * @return The estimated time to uninstall this action (as described above).
     * 
     * @see com.zerog.ia.api.pub.UninstallerProxy
     */
    public long getEstimatedTimeToUninstall(UninstallerProxy ip) {
        return 100;
    }

    /**
     * This method provides a simple progress test algorithm processing
     */
    private void showProgress(ProgressAccess progressAccess) {

        // Set the title
        progressAccess.setProgressTitle("Show Progress");

        progressAccess
                .setProgressDescription("This action is testing progress interaction.");
        progressAccess.setProgressPercentage(0);

        for (int i = 1; i <= 100; i++) {
            progressAccess.setProgressPercentage((float) i);
            progressAccess.setProgressStatusText("My progress is " + i);

            try {
                Thread.sleep(100);
            } catch (InterruptedException e) {
                // Noop
            }
        }
    }
}
