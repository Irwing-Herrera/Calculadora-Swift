//
//  HomeViewController.swift
//  calculadora
//
//  Created by MacBook on 14/07/21.
//

import UIKit

final class HomeViewController: UIViewController {

    // MARK: - Outlets
    
    // Result
    @IBOutlet weak var resultLabel: UILabel!
    
    // Numbers
    @IBOutlet weak var numeroCeroButton: UIButton!
    @IBOutlet weak var numberOneButton: UIButton!
    @IBOutlet weak var numberTwoButton: UIButton!
    @IBOutlet weak var numberThreeButton: UIButton!
    @IBOutlet weak var numberFourtButton: UIButton!
    @IBOutlet weak var numberFiveButton: UIButton!
    @IBOutlet weak var numberSixButton: UIButton!
    @IBOutlet weak var numberSevenButton: UIButton!
    @IBOutlet weak var numberEigthButton: UIButton!
    @IBOutlet weak var numberNineButton: UIButton!
    @IBOutlet weak var numberDecimalButton: UIButton!
    
    // Operator
    @IBOutlet weak var operatorACButton: UIButton!
    @IBOutlet weak var operatorPlusMinusButton: UIButton!
    @IBOutlet weak var operatorPercent: UIButton!
    @IBOutlet weak var operatorDivisionButton: UIButton!
    @IBOutlet weak var operatorMultiplicationButton: UIButton!
    @IBOutlet weak var operatorSubstractionButton: UIButton!
    @IBOutlet weak var operatorAdditionButton: UIButton!
    @IBOutlet weak var operatorResulButton: UIButton!
    
    // MARK: - Variables
    private var total: Double = 0                    // Total
    private var temporal: Double = 0                 // Valor por pantalla
    private var operating: Bool = false              // Indica si se ha seleccionado un operador
    private var decimal: Bool = false                // Indicar si el valor es decimal
    private var operation: OperationTypeEnum = .none // Operacion actual
    
    // MARK: - Constantes
    private let kDecimalSeparator = Locale.current.decimalSeparator   // Obtener el sepador en el idioma del iphone
    private let kMaxLength: Int8 = 9                                  // Mayor numero que se puede ingresar por tecla
    private let kTotal = "Total"                                      // Llave para almacenar el ultimo resultado en pantalla
    
    // Formateo de valares auxiliar
    private let _auxFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        let locale = Locale.current
        formatter.groupingSeparator = ""
        formatter.decimalSeparator = locale.decimalSeparator
        formatter.numberStyle = .decimal
        formatter.maximumIntegerDigits = 100
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = 100
        return formatter
    }()
    
    // Formateo de valares auxiliar totales
    private let _auxTotalFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.groupingSeparator = ""
        formatter.decimalSeparator = ""
        formatter.numberStyle = .decimal
        formatter.maximumIntegerDigits = 100
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = 100
        return formatter
    }()
    
    // Formateo de valores por pantalla por defecto
    private let printFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        let locale = Locale.current
        formatter.groupingSeparator = locale.groupingSeparator
        formatter.decimalSeparator = locale.decimalSeparator
        formatter.numberStyle = .decimal
        formatter.maximumIntegerDigits = 9
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = 8
        return formatter
    }()
    
    private let printScientificFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .scientific
        formatter.maximumFractionDigits = 3
        formatter.exponentSymbol = "e"
        return formatter
    }()
    
    // MARK: - Button Actions
    @IBAction func operatorACAction(_ sender: UIButton) {
        _clear()
        sender.shine()
    }
    @IBAction func operatorPlusMinusAction(_ sender: UIButton) {
        temporal = temporal * (-1)
        resultLabel.text = printFormatter.string(from: NSNumber(value: temporal))
        sender.shine()
    }
    @IBAction func operatorPercentAction(_ sender: UIButton) {
        if operation != .percent {
            _result()
        }
        operating = true
        operation = .percent
        _result()
        
        sender.shine()
    }
    @IBAction func operatorDivisionAction(_ sender: UIButton) {
        if operation != .none {
            _result()
        }
        
        operating = true
        operation = .division
        sender.selecteOperation(true)
        
        sender.shine()
    }
    @IBAction func operatorMultiplicationAction(_ sender: UIButton) {
        if operation != .none {
            _result()
        }
        
        operating = true
        operation = .multiplecation
        sender.selecteOperation(true)
        
        sender.shine()
    }
    @IBAction func operatorSubstractionAction(_ sender: UIButton) {
        if operation != .none {
            _result()
        }
        
        operating = true
        operation = .substraction
        sender.selecteOperation(true)
        
        sender.shine()
    }
    @IBAction func operatorAdditionAction(_ sender: UIButton) {
        if operation != .none {
            _result()
        }
        
        operating = true
        operation = .addiction
        sender.selecteOperation(true)
        
        sender.shine()
    }
    @IBAction func operatorResultAction(_ sender: UIButton) {
        _result()
        sender.shine()
    }
    
    @IBAction func numberDecimalAction(_ sender: UIButton) {
        let currentTemporal = _auxTotalFormatter.string(from: NSNumber(value: temporal))
        if !operating && currentTemporal!.count >= kMaxLength {
            return
        }
        
        resultLabel.text = resultLabel.text! + kDecimalSeparator!
        decimal = true
        
        _selectVisualOperation()
        
        sender.shine()
    }
    
    @IBAction func numberAction(_ sender: UIButton) {
         
        operatorACButton.setTitle("C", for: .normal)
        
        var currentTemporal = _auxTotalFormatter.string(from: NSNumber(value: temporal))
        if !operating && currentTemporal!.count >= kMaxLength {
            return
        }
        
        currentTemporal = _auxFormatter.string(from: NSNumber(value: temporal))
        
        // Hemos seleccionado una operacion
        if operating {
            total = total == 0 ? temporal : total
            resultLabel.text = ""
            currentTemporal = ""
            operating = false
        }
        
        // Hemmos seleccioando decimales
        if decimal {
            currentTemporal = "\(currentTemporal!)\(kDecimalSeparator!)"
            decimal = true
        }
        
        let number = sender.tag
        temporal = Double(currentTemporal! + String(number))!
        resultLabel.text = printFormatter.string(from: NSNumber(value: temporal))
        
        _selectVisualOperation()
        
        sender.shine()
    }
    
    // MARK: - Initialization
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        _loadLastResult()
        _result()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        _setupUI()
    }
    
    // MARK: - Methods private
    private func _loadLastResult() {
        total = UserDefaults.standard.double(forKey: kTotal)
    }
    private func _setupUI() -> Void {
        numeroCeroButton.round()
        numberOneButton.round()
        numberTwoButton.round()
        numberThreeButton.round()
        numberFourtButton.round()
        numberFiveButton.round()
        numberSixButton.round()
        numberSevenButton.round()
        numberEigthButton.round()
        numberNineButton.round()
        numberDecimalButton.round()
            
        operatorACButton.round()
        operatorPlusMinusButton.round()
        operatorPercent.round()
        operatorDivisionButton.round()
        operatorMultiplicationButton.round()
        operatorSubstractionButton.round()
        operatorAdditionButton.round()
        operatorResulButton.round()
        
        // Asignar el separador correcto del dispositivo
        numberDecimalButton.setTitle(kDecimalSeparator, for: .normal)
    }
    
    // Limpia los valores
    private func _clear() -> Void {
        operation = .none
        operatorACButton.setTitle("AC", for: .normal)
        if temporal != 0 {
            temporal = 0
            resultLabel.text = "0"
        } else {
            total = 0
            _result()
        }
    }
    
    // Obtiene el resultado final
    private func _result() -> Void {
        switch operation {
        case .none:
            // No realizar nada
            break
        case .addiction:
            total = total + temporal
            break
        case .substraction:
            total = total - temporal
            break
        case .multiplecation:
            total = total * temporal
            break
        case .division:
            total = total / temporal
            break
        case .percent:
            temporal = temporal / 100
            total = temporal
            break
        }
        
        // Formatear en pantalla
        if let currentTotal = _auxTotalFormatter.string(from: NSNumber(value: total)), currentTotal.count > kMaxLength {
            resultLabel.text = printScientificFormatter.string(from: NSNumber(value: total))
        } else {
            resultLabel.text = printFormatter.string(from: NSNumber(value: total))
        }
        
        operation = .none

        _selectVisualOperation()
        
        UserDefaults.standard.set(total, forKey: kTotal)
        
        print("TOTAL: \(total)")
    }
    
    // Muestra de forma visual la operacion seleccionada
    private func _selectVisualOperation() {
        if !operating {
            // No estamos operando
            operatorAdditionButton.selecteOperation(false)
            operatorSubstractionButton.selecteOperation(false)
            operatorMultiplicationButton.selecteOperation(false)
            operatorDivisionButton.selecteOperation(false)
        } else {
            switch operation {
            case .none, .percent:
                operatorAdditionButton.selecteOperation(false)
                operatorSubstractionButton.selecteOperation(false)
                operatorMultiplicationButton.selecteOperation(false)
                operatorDivisionButton.selecteOperation(false)
                break
            case .addiction:
                operatorAdditionButton.selecteOperation(true)
                operatorSubstractionButton.selecteOperation(false)
                operatorMultiplicationButton.selecteOperation(false)
                operatorDivisionButton.selecteOperation(false)
                break
            case .substraction:
                operatorAdditionButton.selecteOperation(false)
                operatorSubstractionButton.selecteOperation(true)
                operatorMultiplicationButton.selecteOperation(false)
                operatorDivisionButton.selecteOperation(false)
                break
            case .multiplecation:
                operatorAdditionButton.selecteOperation(false)
                operatorSubstractionButton.selecteOperation(false)
                operatorMultiplicationButton.selecteOperation(true)
                operatorDivisionButton.selecteOperation(false)
                break
            case .division:
                operatorAdditionButton.selecteOperation(false)
                operatorSubstractionButton.selecteOperation(false)
                operatorMultiplicationButton.selecteOperation(false)
                operatorDivisionButton.selecteOperation(true)
                break
            }
        }
    }
}
