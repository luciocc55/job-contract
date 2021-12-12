/* eslint-disable no-unused-vars */
import { expect } from "chai";
import { ethers } from "hardhat";
describe("Job", function () {
  before(async function () {
    this.signers = await ethers.getSigners();
    this.owner = this.signers[0];
    this.applicant = this.signers[4];
    this.nonApplicant = this.signers[1];
    const Job = await ethers.getContractFactory("JobsContract", this.owner);
    this.job = await Job.deploy();
    await this.job.deployed();
  });
  it("Should propose Job", async function () {
    // console.log(await this.job.owner(),'OWNER')
    const propose = await this.job.proposeJob(
      "Test Job",
      "Testing if the propose job method actually saves the job in the array"
    );
    console.log(propose);
    const jobasd = await this.job.getJob(0);
    console.log(jobasd, "JOB");
    // expect(propose);
  });
  // it("Should apply to Job", async function () {
  //   const applicantCountStart = await this.job.getApplicantCount(0);
  //   // eslint-disable-next-line no-unused-vars
  //   const apply = await this.job
  //     .connect(this.applicant)
  //     .applyJob(
  //       0,
  //       "Im a developer that has more than 4 years of vue experience",
  //       "Telegram  @AresTEST",
  //       "10EUR per hour"
  //     );
  //   // console.log(apply);

  //   const jobApplied = await this.job.getJob(0);
  //   const applicant = await this.job.getApplicant(
  //     0,
  //     jobApplied.applicantCount - 1
  //   );
  //   expect(applicant[0]).to.equal(this.applicant.address);
  // });
  // it("Should reject choose not applicant to Job", async function () {
  //   await expect(
  //     this.job.chooseApplicant(0, this.nonApplicant.address)
  //   ).to.be.revertedWith(
  //     "Address must be from an active applicant on the job..."
  //   );
  // });
  // it("Should reject choose applicant to Job non owner", async function () {
  //   await expect(
  //     this.job
  //       .connect(this.applicant)
  //       .chooseApplicant(0, this.applicant.address)
  //   ).to.be.revertedWith("Ownable: caller is not the owner");
  // });
  // it("Should edit applicant of Job", async function () {
  //   await expect(
  //     this.job
  //       .connect(this.applicant)
  //       .chooseApplicant(0, this.applicant.address)
  //   ).to.be.revertedWith("Ownable: caller is not the owner");
  // });
});
