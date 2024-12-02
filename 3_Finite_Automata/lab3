class FiniteAutomaton:
    def __init__(self):
        self.states = []
        self.alphabet = []  # Modified to contain 'x' and 'y'
        self.start_state = None
        self.final_states = []
        self.transitions = {}

    def add_state(self, state):
        if state not in self.states:
            self.states.append(state)

    def add_alphabet(self, symbol):
        if symbol not in self.alphabet:
            self.alphabet.append(symbol)

    def set_start_state(self, state):
        if state not in self.states:
            raise ValueError(f"Start state {state} is not a valid state")
        self.start_state = state

    def add_final_state(self, state):
        if state not in self.states:
            raise ValueError(f"Final state {state} is not a valid state")
        self.final_states.append(state)

    def add_transition(self, from_state, symbol, to_state):
        if from_state not in self.states or to_state not in self.states:
            raise ValueError(f"Invalid transition: {from_state} -> {to_state} on {symbol}")
        if symbol not in self.alphabet:
            raise ValueError(f"Invalid symbol in transition: {symbol}")
        self.transitions.setdefault((from_state, symbol), []).append(to_state)

    def display_components(self):
        """Display the components of the finite automaton."""
        print("Finite Automaton Components:")
        print(f"States: {self.states}")
        print(f"Alphabet: {self.alphabet}")
        print(f"Start State: {self.start_state}")
        print(f"Final States: {self.final_states}")
        print("Transitions:")
        for (from_state, symbol), to_states in self.transitions.items():
            print(f"  δ({from_state}, {symbol}) -> {to_states}")
    
    def verify_token(self, token):
        """Verify if a token is valid by simulating the automaton."""
        current_state = self.start_state
        for symbol in token:
            if (current_state, symbol) not in self.transitions:
                return False  # No valid transition for the current state and symbol
            current_state = self.transitions[(current_state, symbol)][0]  # Move to the next state
        
        return current_state in self.final_states  # The token is valid if the final state is reached

def read_fa_file(filename):
    fa = FiniteAutomaton()
    
    with open(filename, 'r') as file:
        lines = file.readlines()
    
    # Parse the components from the file
    in_transitions_section = False
    for line in lines:
        line = line.strip()
        
        if line.startswith("STARI:"):
            states = line[len("STARI:"):].strip().split()
            for state in states:
                fa.add_state(state)
        
        elif line.startswith("ALFABET:"):
            alphabet = line[len("ALFABET:"):].strip().split()
            for symbol in alphabet:
                fa.add_alphabet(symbol)
        
        elif line.startswith("STARE_INIT:"):
            fa.set_start_state(line[len("STARE_INIT:"):].strip())
        
        elif line.startswith("STARI_FINALE:"):
            final_states = line[len("STARI_FINALE:"):].strip().split()
            for state in final_states:
                fa.add_final_state(state)
        
        elif line.startswith("TRANZITII:"):
            in_transitions_section = True
            continue  # Skip the "TRANZITII:" line itself
        
        elif in_transitions_section:
            # Each transition should be on a new line
            if line:
                from_state, symbol, to_state = line.split()
                fa.add_transition(from_state, symbol, to_state)

    return fa


if __name__ == "__main__":
    # Specify the filename containing the FA description
    filename = "FA.in"
    
    try:
        fa = read_fa_file(filename)
        fa.display_components()

        # Ask user to input a string and verify if it's a valid token
        token = input("Enter a string to verify if it's a valid token (only 'x' and 'y' allowed): ").strip()
        
        # Validate token (should contain only 'x' and 'y')
        if any(char not in ['x', 'y'] for char in token):
            print("Invalid token: Only 'x' and 'y' are allowed.")
        elif fa.verify_token(token):
            print(f"'{token}' is a valid token.")
        else:
            print(f"'{token}' is NOT a valid token.")
    
    except Exception as e:
        print(f"Error: {e}")
