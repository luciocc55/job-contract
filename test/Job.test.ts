/* eslint-disable no-unused-vars */
import chai from "chai";
import { solidity } from "ethereum-waffle";
import { ethers } from "hardhat";
describe("Job", function () {
  before(async function () {
    chai.use(solidity);
    this.signers = await ethers.getSigners();
    this.owner = this.signers[0];
    this.applicant = this.signers[4];
    this.nonApplicant = this.signers[1];
    const Job = await ethers.getContractFactory("JobsContract", this.owner);
    this.job = await Job.deploy();
    await this.job.deployed();
  });
  it("Invalid Job", async function () {
    await chai.expect(this.job.getJob(999)).revertedWith("Invalid job...");
  });
  it("Should propose Job", async function () {
    const textJob = "Test Job";
    const descJob =
      "Testing if the propose job method actually saves the job in the array";
    const propose = await this.job.proposeJob(textJob, descJob);
    const numberJobs = await this.job.getJobsCount();
    chai.expect(numberJobs).equal(1);
    const jobProposed = await this.job.getJob(0);
    chai.expect(jobProposed.title).equal(textJob);
    chai.expect(jobProposed.description).equal(descJob);
  });
  it("Should apply for the job", async function () {
    const apply = await this.job
      .connect(this.applicant)
      .applyJob(
        0,
        "Im a developer since 5 years ago with experience on blockchain",
        "@TESTcontact telegram",
        "9EUR per hour"
      );
    const applyJob = await this.job.getApplicant(0, 0);
    chai.expect(applyJob.addr).equal(this.applicant.address);
    const quantityApplicants = await this.job.getApplicantCount(0);
    chai.expect(quantityApplicants).equal(1);
  });
  it("Should reject the non-applicant for the job", async function () {
    await chai
      .expect(this.job.chooseApplicant(0, this.nonApplicant.address))
      .revertedWith("Address must be from an active applicant on the job...");
  });
  it("Should choose the applicant for the job", async function () {
    const applicant2 = await this.job.chooseApplicant(
      0,
      this.applicant.address
    );
    const jobProposed = await this.job.getJob(0);
    chai.expect(jobProposed.selectedApplicant).equal(this.applicant.address);
  });
  it("Should reject the applicant for the job because the job is already taken", async function () {
    await chai
      .expect(
        this.job
          .connect(this.nonApplicant)
          .applyJob(
            0,
            "TEST NON APPLICANT",
            "@NONAPPLCONTACT telegram",
            "5EUR per hour"
          )
      )
      .revertedWith("Job must be open for you to apply...");
  });
  it("Should not destruct since not the owner", async function () {
    // console.log(await this.job.owner(),'OWNER')
    await chai
      .expect(this.job.connect(this.applicant).destroyJob(0))
      .to.be.revertedWith("Ownable: caller is not the owner");
  });
  it("Should destruct the previous proposed job", async function () {
    // console.log(await this.job.owner(),'OWNER')
    const destruct = await this.job.destroyJob(0);
    await chai
      .expect(this.job.getJob(0))
      .to.be.revertedWith("function call to a non-contract account");
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
