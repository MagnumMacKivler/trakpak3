
--E2 function descriptions
E2Helper.Descriptions["quickSetupAutoCouplers(e:nnn)"] = "Quickly adds AutoCouplers to carbody E. Tolerance is the max distance from the centerline required to couple. Slack is the amount of slack in the coupler (0 = Rigid). Returns the number of couplers created or pre-existing."
E2Helper.Descriptions["clearAutoCouplers(e:)"] = "Removes AutoCouplers from the selected entity. Does not decouple cars. Returns 1 on success."
E2Helper.Descriptions["hasAutoCouplers(e:)"] = "Returns 1 if the selected entity has AutoCouplers."
E2Helper.Descriptions["isAutoCoupled(e:n)"] = "Returns 1 if the specified coupler is coupled to another car. Use 1 for the front coupler, -1 for the rear coupler. If you use 0, returns the total number of couplers which are coupled to another car."