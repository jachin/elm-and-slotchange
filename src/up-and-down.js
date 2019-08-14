const makeUpAndDown = () => {

    const template = document.createElement('template');
    template.innerHTML = `
    <div id="wrapper">
        <button id="down-button">-</button>
        <div id="count"></div>
        <button id="up-button">+</button>
        <slot name="direction-label">
        </slot>
    </div>
    `;

    window.customElements.define(
        "up-and-down",
        class UpAndDown extends HTMLElement {

            constructor() {
                super();
                this._count = 0;
            }

            connectedCallback() {
                if (this.shadowRoot) {
                    return;
                }
                const shadowRoot = this.attachShadow({mode: "open"});
                shadowRoot.appendChild(template.content.cloneNode(true));
                shadowRoot.querySelector("#count").textContent = this.count;

                shadowRoot.querySelector("#down-button").addEventListener("click", () => {
                    this.count -= 1;
                });

                shadowRoot.querySelector("#up-button").addEventListener("click", () => {
                    this.count += 1;
                });

                this.shadowRoot.querySelector("slot[name='direction-label']").addEventListener("slotchange", e => {
                    console.log("slotchange", e);
                });
            }

            static get observedAttributes() {
                return ["count"];
            }

            attributeChangedCallback(name, oldValue, newValue) {
                if (name === 'count') {
                    this.count = newValue;
                    if (this.shadowRoot) {
                        this.shadowRoot.querySelector("#count").textContent = this.count;
                    }
                } else {
                    throw new Error(`Unknown attribute: {$name}`);
                }
            }

            get count() {
                return this._count;
            }

            set count(val) {
                this._count = Number.parseInt(val);
                if (this.shadowRoot) {
                    this.shadowRoot.querySelector("#count").textContent = this._count;
                }
                this.dispatchEvent(new CustomEvent(
                    "countChange",
                    {detail: {count: this.count}})
                );
            }
        }
    );
};

makeUpAndDown();
