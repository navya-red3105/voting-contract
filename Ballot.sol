pragma solidity ^0.8.0;

contract Ballot {

    struct Voter {
        uint weight;
        bool voted;
        uint8 vote;
    }

    struct Proposal {
        uint voteCount;
    }

    address public chairperson;
    mapping(address => Voter) public voters;
    Proposal[] public proposals;

    constructor(uint8 _numProposals) {
        chairperson = msg.sender;
        voters[chairperson].weight = 2;

        for (uint8 i = 0; i < _numProposals; i++) {
            proposals.push(Proposal({voteCount: 0}));
        }
    }

    function register(address toVoter) public {
        require(msg.sender == chairperson, "Only chairperson can register");
        require(!voters[toVoter].voted, "Voter already voted");

        voters[toVoter].weight = 1;
    }

    function vote(uint8 toProposal) public {
        Voter storage sender = voters[msg.sender];

        require(!sender.voted, "Already voted");
        require(toProposal < proposals.length, "Invalid proposal");

        sender.voted = true;
        sender.vote = toProposal;
        proposals[toProposal].voteCount += sender.weight;
    }

    function winningProposal() public view returns (uint8 _winningProposal) {
        uint winningVoteCount = 0;

        for (uint8 prop = 0; prop < proposals.length; prop++) {
            if (proposals[prop].voteCount > winningVoteCount) {
                winningVoteCount = proposals[prop].voteCount;
                _winningProposal = prop;
            }
        }
    }
}