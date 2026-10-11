# Attribution and disclosure

JD Jones directs and maintains this project. OpenAI models assisted with the
mathematical arguments, computational certificates, Lean implementation,
source comparisons and independent checks. Symbolic and numerical exploration
supported construction of the exact certificates.

The planar cubic family and its published stability and all-degree obstruction
are due to Jun Liu and Maxwell Fitzsimmons. The rational-certificate method
also follows their construction. [Sources](docs/Sources.md) gives the primary
references and distinguishes these inputs from the results proved here.
No external proof implementation was copied.

The Lean contract and written analytic supplements have different coverage;
[Verification](VERIFICATION.md) specifies that boundary. Exact symbolic replay
checks finite identities, while the formal proof is checked by the stated
kernels. Neither constitutes external peer review or establishes priority.
