//
// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU Lesser General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
// 
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU Lesser General Public License for more details.
// 
import inet.networklayer.configurator.ipv4.Ipv4NetworkConfigurator;
import inet.networklayer.ipv4.RoutingTableRecorder;
import inet.node.ethernet.Eth10G;
import inet.node.inet.Router;
import inet.node.inet.StandardHost;
import inet.physicallayer.wireless.apsk.packetlevel.ApskScalarRadioMedium;
import simu5g.common.binder.Binder;
import simu5g.common.carrierAggregation.CarrierAggregation;
import simu5g.nodes.NR.NRUe;
import simu5g.nodes.NR.gNodeB;
import simu5g.nodes.Upf;
import simu5g.nodes.backgroundCell.BackgroundCell;
import simu5g.world.radio.ChannelControl;
import simu5g.world.radio.LteChannelControl;
import inet.visualizer.contract.IIntegratedVisualizer;
import inet.environment.common.PhysicalEnvironment;
import inet.physicallayer.wireless.common.contract.packetlevel.IRadioMedium;

// SingleCell
//
// This network represents the deployment option 3 in 3GPP 38.801
//
network SingleCell
{
    parameters:
        int numUe;
        int numBgCells = default(0);
        @display("i=block/network2;bgb=1000,1000");
        @figure[title](type=label; pos=0,-1; anchor=sw; color=white);

    submodules:
        //visualizer: <default(firstAvailableOrEmpty("IntegratedCanvasVisualizer"))> like IIntegratedVisualizer if typename != "" {
        //    @display("p=60,633");
        //}
        //physicalEnvironment: PhysicalEnvironment {
        //    @display("p=58,783");
        //}
        channelControl: LteChannelControl {
            @display("p=114,92;is=s");
        }
        routingRecorder: RoutingTableRecorder {
            @display("p=114,177;is=s");
        }
        configurator: Ipv4NetworkConfigurator {
            @display("p=114,291");
        }
        binder: Binder {
            @display("p=114,410;is=s");
        }
        carrierAggregation: CarrierAggregation {
            @display("p=114,512;is=s");
        }
        server: StandardHost {
            @display("p=337,114;is=n;i=device/server");
        }
        router: Router {
            @display("p=498,112;i=device/smallrouter");
        }
        upf: Upf {
            @display("p=673,112");
        }
        iUpf: Upf {
            @display("p=847,112");
        }
        gnb: gNodeB {
            @display("p=728,411;is=vl");
        }
        ue[numUe]: NRUe {
            @display("p=597,609");
        }
        //radioMedium: <default("UnitDiskRadioMedium")> like IRadioMedium {
        //    @display("p=938,715");
        //}
    connections:
        server.pppg++ <--> Eth10G <--> router.pppg++;
        router.pppg++ <--> Eth10G <--> upf.filterGate;
        upf.pppg++ <--> Eth10G <--> iUpf.pppg++;
        iUpf.pppg++ <--> Eth10G <--> gnb.ppp;
}

